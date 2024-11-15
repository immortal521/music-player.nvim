local M = {}

local term = package.loaded["toggleterm"]

if not term then
    term = require("toggleterm")
end

local function get_download_url()
    local base_url = "https://github.com/immortal521/bucketApps/releases/download/music-player/music-player"
    local os_type = jit.os
    if os_type == "Linux" then
        return base_url           -- Linux 系统的二进制文件
    elseif os_type == "Windows" then
        return base_url .. ".exe" -- Windows 系统的二进制文件
    else
        vim.notify("Unsupported OS: " .. os_type, vim.log.levels.ERROR)
        return nil -- 返回 nil 表示无法生成下载链接
    end
end

local function ensure_dir_exists(dir)
    -- 使用 vim.fn.mkdir 来创建目录，如果目录已经存在则不会报错
    vim.fn.mkdir(dir, "p") -- "p" 参数表示创建父目录（如果需要）
end

local function get_bin_path()
    local base_url = vim.fn.stdpath("data") .. "/lazy/nvim-music-player/bin/"

    ensure_dir_exists(base_url)
    local os_type = jit.os
    if os_type == "Linux" then
        return base_url .. "music-player"
    elseif os_type == "Windows" then
        return base_url .. "music-player.exe" -- Windows 系统的二进制文件
    else
        vim.notify("Unsupported OS: " .. os_type, vim.log.levels.ERROR)
        return nil
    end
end

local default_opts = {
    bin_path = get_bin_path(),
    download_url = get_download_url(),
    keymap = "<Leader>Tm",
}

local function download_binary(bin_path, download_url)
    if not vim.fn.filereadable(bin_path) then
        local cmd = string.format("wget -O %s %s", bin_path, download_url)
        -- vim.fn.system(cmd)
    end
end

local function setup_keymaps(keymap, bin_path)
    vim.keymap.set("n", keymap, function()
            term.exec(bin_path, 9, 0, vim.loop.cwd(), "float")
        end,
        { noremap = true, silent = true })
end

function M.setup(opts)
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})
    download_binary(opts.bin_path, opts.download_url)
    setup_keymaps(opts.keymap, opts.bin_path)
end

return M
