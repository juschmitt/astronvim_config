-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

---@type LazySpec
return {
  {
    -- convert current buffer to PDF
    vim.api.nvim_create_user_command("NoteToPDF", function()
      local pandoc_opts = "--pdf-engine=weasyprint "
      local filename = vim.fn.expand "%:r"
      vim.cmd('!pandoc "' .. vim.fn.expand "%" .. '" ' .. pandoc_opts .. ' -o "' .. filename .. '.pdf"')
    end, {}),

    -- convert visual selection to PDF
    vim.api.nvim_create_user_command("SelectionToPDF", function(opts)
      -- Get the file where to save the PDF
      local output_file = vim.fn.input("Save PDF as: ", "selection.pdf", "file")
      if output_file == "" then return end

      -- Get the selected lines
      local start_line = opts.line1
      local end_line = opts.line2

      -- Create a temporary file with the selection
      local temp_file = os.tmpname()
      vim.cmd(start_line .. "," .. end_line .. "write! " .. temp_file)

      -- Convert the temp file to PDF using Weasyprint
      vim.cmd("!pandoc " .. temp_file .. " --pdf-engine=weasyprint -o " .. output_file)

      -- Remove the temporary file
      vim.fn.delete(temp_file)

      print("PDF saved as: " .. output_file)
    end, { range = true }),

    -- convert visual selection to PDF
    vim.api.nvim_create_user_command("SelectionToPDFJustified", function(opts)
      -- Get the file where to save the PDF
      local output_file = vim.fn.input("Save PDF as: ", "selection.pdf", "file")
      if output_file == "" then return end

      -- Get the selected lines
      local start_line = opts.line1
      local end_line = opts.line2

      -- Create a temporary file with the selection
      local temp_file = os.tmpname()
      vim.cmd(start_line .. "," .. end_line .. "write! " .. temp_file)

      -- Convert the temp file to PDF using Weasyprint
      vim.cmd(
        "!pandoc " .. temp_file .. " --css='body { text-align: justify; }' --pdf-engine=weasyprint -o " .. output_file
      )

      -- Remove the temporary file
      vim.fn.delete(temp_file)

      print("PDF saved as: " .. output_file)
    end, { range = true }),

    -- set keymaps
    vim.keymap.set("n", "<leader>zp", "<cmd>NoteToPDF<CR>", { silent = true }),
    vim.keymap.set("v", "<leader>zp", "<cmd>SelectionToPDF<CR>", { silent = true }),
  },
}
