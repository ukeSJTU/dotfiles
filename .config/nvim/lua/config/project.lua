local M = {}

local js_root_markers = {
  'pnpm-lock.yaml',
  'package-lock.json',
  'yarn.lock',
  'bun.lock',
  'bun.lockb',
  '.git',
}

local js_tools = {
  oxfmt = {
    configs = { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts', 'oxfmt.config.mts' },
    dependencies = { 'oxfmt' },
  },
  biome = {
    configs = { 'biome.json', 'biome.jsonc', '.biome.json', '.biome.jsonc' },
    dependencies = { '@biomejs/biome' },
  },
  prettier = {
    configs = {
      '.prettierrc',
      '.prettierrc.json',
      '.prettierrc.json5',
      '.prettierrc.yaml',
      '.prettierrc.yml',
      '.prettierrc.toml',
      '.prettierrc.js',
      '.prettierrc.cjs',
      '.prettierrc.mjs',
      '.prettierrc.ts',
      '.prettierrc.cts',
      '.prettierrc.mts',
      'prettier.config.js',
      'prettier.config.cjs',
      'prettier.config.mjs',
      'prettier.config.ts',
      'prettier.config.cts',
      'prettier.config.mts',
    },
    dependencies = { 'prettier' },
  },
}

local function start_dir(path)
  if not path or path == '' then
    return vim.uv.cwd()
  end

  local normalized = vim.fs.normalize(path)
  local stat = vim.uv.fs_stat(normalized)
  return stat and stat.type == 'directory' and normalized or vim.fs.dirname(normalized)
end

local function find_boundary(dir, markers, fallback)
  return vim.fs.root(dir, markers) or (fallback and vim.fs.root(dir, fallback)) or dir
end

local function each_ancestor(dir, boundary, callback)
  local current = dir
  while current do
    if callback(current) then
      return true
    end
    if current == boundary then
      break
    end

    local parent = vim.fs.dirname(current)
    if parent == current or not vim.startswith(current, boundary .. '/') then
      break
    end
    current = parent
  end
  return false
end

local function file_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function package_has_dependency(path, dependencies)
  local file = io.open(path, 'r')
  if not file then
    return false
  end

  local content = file:read '*a'
  file:close()

  local ok, package = pcall(vim.json.decode, content)
  if not ok or type(package) ~= 'table' then
    return false
  end

  local dependency_groups = { 'dependencies', 'devDependencies', 'peerDependencies', 'optionalDependencies' }
  for _, group in ipairs(dependency_groups) do
    if type(package[group]) == 'table' then
      for _, dependency in ipairs(dependencies) do
        if package[group][dependency] ~= nil then
          return true
        end
      end
    end
  end
  return false
end

function M.has_js_tool(path, tool)
  local spec = assert(js_tools[tool], 'Unknown JavaScript tool: ' .. tool)
  local dir = start_dir(path)
  local boundary = find_boundary(dir, js_root_markers, 'package.json')

  return each_ancestor(dir, boundary, function(ancestor)
    for _, config in ipairs(spec.configs) do
      if file_exists(vim.fs.joinpath(ancestor, config)) then
        return true
      end
    end
    return package_has_dependency(vim.fs.joinpath(ancestor, 'package.json'), spec.dependencies)
  end)
end

function M.uses_ruff(path)
  local dir = start_dir(path)
  local boundary = find_boundary(dir, { 'uv.lock', '.git' }, 'pyproject.toml')

  return each_ancestor(dir, boundary, function(ancestor)
    if file_exists(vim.fs.joinpath(ancestor, 'ruff.toml')) or file_exists(vim.fs.joinpath(ancestor, '.ruff.toml')) then
      return true
    end

    local file = io.open(vim.fs.joinpath(ancestor, 'pyproject.toml'), 'r')
    if not file then
      return false
    end
    local content = file:read '*a'
    file:close()
    return content:find '%f[%w]ruff%f[^%w_-]' ~= nil
  end)
end

return M
