-- Guide
	-- map expands RHS
	-- noremap uses original
	-- map = n+v+s+o
	-- map! = i+c
	-- to change operatorending mode,
	-- onoremap <expr> O v:operator == 'd' ? ':.diffget<cr>' : '<'
	-- :lmap applies to insert, command line etc

-- Packages + plugins
	vim.cmd('packadd! gruvbox-material')

-- Options
	vim.opt.relativenumber = true
	vim.opt.number = true
	vim.opt.compatible = false
	vim.opt.equalalways = true
	vim.opt.mouse = 'a'
	vim.opt.wrap = false
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.autoindent = true
	vim.opt.ignorecase = true
	vim.opt.selection = 'exclusive'
	" do not store vimrc values from the prev session
		vim.opt.sessionoptions:remove('options')
	" Don't make Esc mapping interfere with keycodes
		vim.opt.timeout = true
		vim.opt.timeoutlen = 800
		vim.opt.ttimeoutlen = 100
		vim.opt.updatetime = 500

	-- Highlighting
		-- Colorscheme
			-- NOTE: autocmd Colorscheme * before any highlights
			vim.cmd('colorscheme gruvbox-material')
			
		-- Function: Show Colors
			function ShowColors()
				-- Highlight each number using its own color slot
				for i = 0, 15 do
					 vim.api.nvim_set_hl(0, "Color" .. i, { ctermbg = i, ctermfg = "NONE" })
					-- Print the number with its color
						vim.api.nvim_out_write(i .. " ")
						vim.cmd("echohl Color" .. i)
						vim.api.nvim_out_write("Color\n")
						vim.cmd("echohl NONE")
				end
			end
			--" call: ShowColors()

		-- diff highlight easier to read
			vim.api.nvim_create_autocmd("Colorscheme", {
				pattern = "*",
				command = "highlight DiffChanged ctermfg=black"
			})
			
		-- search results 
			vim.opt.incsearch = true
			vim.opt.hlsearch = true
			
		-- cursor/currline using 16-colour format
			-- 0 = black
			-- 3 = brown/yellow
			-- 5 = orange (or pink)
			-- 15 = white
			vim.opt.cursorline = true
			--" highlight CursorLine gui=bold cterm=italic ctermfg=0 ctermbg=3
			vim.api.nvim_create_autocmd("Colorscheme", {
				pattern = "*",
				command = "highlight CursorLine gui=bold ctermfg=0 ctermbg=3"
			})

		-- Cursor styling
			-- Insert mode: I-beam cursor
				vim.opt.t_SI = "\e[6 q" 
			-- Normal mode: Block cursor
				vim.opt.t_EI = "\e[2 q" 

		-- highlight folded lines
		vim.api.nvim_create_autocmd("Colorscheme", {
			pattern = "*",
			command = "highlight Folded ctermfg=5 ctermbg=11"
		})

	-- Folding
		-- fold under bash comments
			vim.opt.foldignore = ""
			vim.opt.foldminlines = 0

-- Editing
    -- meta
        -- vimscript comment
			vim.keymap.set('n', '"', 'mqI"<Space><Esc>`q<Right><Right>', { noremap = true })
		-- assign multiple keymaps for one mode
			function isTable(obj)
				return type(obj) == 'table'
			end
			
			function toArr(obj)
				if isTable(obj) then
					obj_arr = obj
				else
					obj_arr = {obj}
				end
				return obj_arr
			end

			function toDoubleArr(obj)
				if isTable(obj[0]) then
					obj_arr = obj
				else
					obj_arr = {obj}
				end
				return obj_arr
			end

			function keymap(modes,mappings)
				modes_arr = toArr(modes)
				mappings_arr = toDoubleArr(mappings)

				for i,mode in ipairs(modes_arr)
					for j,mapping in ipairs(mappings_arr)
						vim.keymap.set(mode,mapping[0],mapping[1]))
					end
				end
			end

    -- Mode switching
        -- to command
            --" vim.keymap.set('n', ':', ';', { noremap = true })
            vim.keymap.set('n', ';', ':', { noremap = false })
            vim.keymap.set('v', ';', ':', { noremap = true })
            vim.keymap.set('o', ';', ':', { noremap = true })
            -- command mode self-reference
                vim.keymap.set('c', ';', ':', { noremap = true })
                -- still allow typing ;
                    vim.keymap.set('c', '\;', ';', { noremap = true })

        -- to insert
            -- before/after cursor block
                vim.keymap.set('n', 'aa', 'a', { noremap = true })
                vim.keymap.set('n', 'al', 'a', { noremap = true })
                vim.keymap.set('n', 'aj', 'i', { noremap = true })
            -- in newline above/below
                vim.keymap.set('n', 'ai', 'O', { noremap = true })
                vim.keymap.set('n', 'ak', 'o', { noremap = true })
        -- to normal
            vim.keymap.set('i', ';;', '<Esc>', { noremap = true })
            vim.keymap.set('i', 'aa', '<Esc>', { noremap = true })
            vim.keymap.set('c', ';;', '<C-c>', { noremap = true })

    -- Navigation directions
        -- normal + visual + operator
            vim.keymap.set('', 'j', 'b', { noremap = true })
            vim.keymap.set('', 'k', 'j', { noremap = true })
            vim.keymap.set('', 'i', 'k', { noremap = true })
            vim.keymap.set('', 'l', 'w', { noremap = true })
            -- characterwise, start/end of line
                vim.keymap.set('', 'L', 'l', { noremap = true })
				-- originally Join lines, i don't need this
					vim.keymap.set('', 'J', 'h', { noremap = true })
				-- originally insert before first non-blank column in line
				-- this will be remapped below 
					vim.keymap.set('', 'I', '^', { noremap = true })
				-- originally Look up Keyword, I don't need this
					vim.keymap.set('', 'K', '$', { noremap = true })
                vim.keymap.set('', 'II', 'gg', { noremap = true })
                vim.keymap.set('', 'Ii', 'gg', { noremap = true })
                vim.keymap.set('', 'KK', 'G$', { noremap = true })
                vim.keymap.set('', 'Kk', 'G$', { noremap = true })

        -- operator + visual
            -- remap inner and outer text objects
                vim.keymap.set('o', ',', 'i', { noremap = true })
                vim.keymap.set('o', '.', 'a', { noremap = true })
                vim.keymap.set('o', 'w', 'iw', { noremap = true })
                vim.keymap.set('o', '#', 'i"', { noremap = true })
                vim.keymap.set('o', '{', 'i{', { noremap = true })
                vim.keymap.set('v', ',', 'i', { noremap = true })
                vim.keymap.set('v', '.', 'a', { noremap = true })
                vim.keymap.set('v', 'w', 'iw', { noremap = true })
                vim.keymap.set('v', '"', 'i"', { noremap = true })
                vim.keymap.set('v', '{', 'i{', { noremap = true })

		-- visual
			vim.keymap.set('v', 'l', 'e', { noremap = true })
			-- to visual line
				vim.keymap.set('v', 'k', '<C-v>Vj', { noremap = true })
				vim.keymap.set('v', 'i', '<C-v>Vk', { noremap = true })
				vim.keymap.set('v', 'j', '<C-v>vh', { noremap = true })
				vim.keymap.set('v', 'l', '<C-v>vl', { noremap = true })

	-- insert something
		vim.keymap.set('i', ';j', '<Left>', { noremap = true })
		vim.keymap.set('i', ';k', '<Down>', { noremap = true })
		vim.keymap.set('i', ';i', '<Up>', { noremap = true })
		vim.keymap.set('i', ';l', '<Right>', { noremap = true })

	-- Paste
		-- swap pastes
			vim.keymap.set('n', 'p', 'P', { noremap = true })
			vim.keymap.set('n', 'P', 'p', { noremap = true })
		-- paste directly into word
			vim.keymap.set('n', 'C', 'vp', { noremap = true })

	-- undo and redo consolidate to U key
		vim.keymap.set('n', 'U', '<C-r> ', { noremap = true })

	-- Search
		-- s: search pcre-like
			vim.keymap.set('n', '/', '/\v', { noremap = true })
			vim.keymap.set('n', 's', '/\v', { noremap = true })
		-- S: substitute globally
			vim.keymap.set('n', 'S', ':%s///g<Left><Left>', { noremap = true })


	-- new line but stay in normal
		-- quite hacky but it inserts a '.' and then erases it to preserve indent
		vim.keymap.set('n', '<CR>', 'o.<Esc>"_x', { noremap = true })
		vim.keymap.set('n', '<Backspace>', 'i<Backspace><Esc> ', { noremap = true })
		vim.keymap.set('v', '<Backspace>', 'i<Backspace><Esc> ', { noremap = true })
	
    -- Indentation
        vim.keymap.set('n', '<Tab>', '>>', { noremap = true })
        vim.keymap.set('v', '<Tab>', '>', { noremap = true })
        vim.keymap.set('o', '<Tab>', '>', { noremap = true })

    -- Folding
        -- fold all, unfold current line
            vim.keymap.set('n', '<Space><Space>', 'zx', { noremap = true })
            vim.keymap.set('n', '<Space>k', 'jzx', { noremap = true })
        -- fold all
            vim.keymap.set('n', '<Space>a', 'zM', { noremap = true })
        -- Move between fold sections
            -- go to next/previous fold (closest one of start/end)
                vim.keymap.set('n', '<Space>i', 'zk', { noremap = true })
                vim.keymap.set('n', '<Space>k', 'zj', { noremap = true })
            -- go to start/end of current fold scope, or otherwise to containing scope
                vim.keymap.set('n', '<Space>j', '[z', { noremap = true })
                vim.keymap.set('n', '<Space>l', ']z', { noremap = true })
        vim.opt.foldmethod = 'indent'
        vim.opt.foldtext = 'v:lua.MyFoldText()'
        vim.opt.fillchars = { fold = ' ', vert = '|' }
        function MyFoldText()
            local line = vim.fn.getline(vim.v.foldstart)
            local subSimple = line:gsub('/%*|%*/|{{{\d?|-', '')
            local subTabs = subSimple:gsub('\t', '    ')
            return subTabs .. '     .      .     .    .   .   .  .  . . ............................'
        end
        vim.keymap.set('n', '<LeftMouse>', '<LeftMouse>zx', { noremap = true })

    -- Recording
        vim.keymap.set('', ',,', 'q', { noremap = true })
        vim.keymap.set('', ',.', '@', { noremap = true })
        vim.keymap.set('', ',..', '@@', { noremap = true })

  -- Search
		-- Enter to go to next result, Esc to quit
		local function TmSearchNext()
		  if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
			-- if search, go to next one and expand fold
			return "\<C-g>\<Cmd>lua vim.cmd('normal! zx')\<CR>"
		  else
			  return "\<CR>"
		  end
		end

		local function TmSearchEsc()
		  if (vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?') and vim.fn.getcmdline() ~= '\v' then
				return "\<CR>"
		  else
			return "\<C-C>"
		  end
		end

		vim.keymap.set('c', '<CR>', TmSearchNext, { expr = true })
		vim.keymap.set('c', '£', '<CR>')
		vim.keymap.set('c', '<Esc>', TmSearchEsc, { expr = true })
		vim.keymap.set('c', '<Esc>[', '<Esc>[', { noremap = true })

		-- Automatically open folds when jumping to a search result
		-- originally was zxzz to center cursor
		vim.api.nvim_create_autocmd('CursorHold', {
			callback = function()
				if vim.fn.mode() ~= 'i' then
					vim.cmd('normal! zx')
				end
			end,
		})


-- Workspace 
	-- switch windows
	vim.keymap.set('n', 'tk', '<C-w>w')
	vim.keymap.set('n', 'ti', '<C-w>W')
	vim.keymap.set('n', 'tj', function() vim.cmd('tabN') end)
	vim.keymap.set('n', 'tl', function() vim.cmd('tabn') end)
	vim.keymap.set('n', 'tm', '<C-w>T')
	vim.keymap.set('n', 'ta', function() vim.cmd('tab sball') end)

	-- exit vim
		-- <CR> is used for Enter
		vim.keymap.set('n', 'qq', function() vim.cmd('x') end)
		vim.keymap.set('n', 'qa', function() vim.cmd('confirm qa') end)
		vim.keymap.set('n', 'q', function() vim.cmd('confirm quit') end)

	-- save
		vim.keymap.set('n', 'w', function() vim.cmd('w') end)
		vim.keymap.set('n', ':w', ':w', { noremap = true })

-- Sessions
local function SessionWrite(sessname)
    vim.cmd('mks! ~/.vim/sessions/' .. sessname)
end

vim.api.nvim_create_user_command('Sw', function(opts)
    SessionWrite(opts.args)
end, { nargs = 1, complete = 'file' })

-- Command abbreviations
local abbreviations = {
    e = "tabf",
    t = "tabf",
    v = "vs",
    sw = "Sw",
    se = "source ~/.vim/sessions",
    vedt = "tabf ~/.vim/vimrc",
    tedt = "tabf ~/.termux/termux.properties",
    bedt = "tabf ~/.bashrc",
    vrc = "~/.vim/vimrc",
    trc = "~/.termux/termux-properties",
    brc = "~/.bashrc",
    vsrc = "source ~/.vim/vimrc"
}

for lhs, rhs in pairs(abbreviations) do
    vim.api.nvim_create_user_command(lhs, function()
        vim.cmd(rhs)
    end, {})
end

-- Autocommands
	-- create dir if it doesnt exist when editing new file
	vim.api.nvim_create_augroup('Mkdir', { clear = true })
	vim.api.nvim_create_autocmd('BufWritePre', {
		group = 'Mkdir',
		pattern = '*',
		callback = function()
			vim.fn.mkdir(vim.fn.expand('<afile>:p:h'), 'p')
		end,
	})

	vim.api.nvim_create_augroup('Vsrc', { clear = true })
	vim.api.nvim_create_autocmd('BufWritePost', {
	  group = 'Vsrc',
	  pattern = 'vimrc',
	  callback = function()
		  vim.cmd('source ' .. vim.fn.expand('<afile>:p'))
	  end,
	})



  local function TmSearchUnfold()
      -- execute "<C-C>"
      -- if getcmdtype() !=# '/' && getcmdtype() !=# '?'
          -- return
      -- endif		
      vim.cmd('normal! zx')
      -- let cmdName = '^MyFancySearch\s'
      -- let cmdLine=getcmdline()
      -- if cmdLine !~# cmdName
          -- return
      -- endif
      -- let pattern = substitute(cmdLine, cmdName, '', '')
      -- let @/="tm"
      -- set hlsearch
      -- redraw
  end

  vim.api.nvim_create_augroup('TmSearchUnfold', { clear = true })
  vim.api.nvim_create_autocmd('CmdlineChanged', {
      group = 'TmSearchUnfold',
      pattern = '/',
      callback = TmSearchUnfold,
  })
