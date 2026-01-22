# IPython defaults for this repo
c = get_config()

# UI/UX
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.autocall = 1
c.TerminalInteractiveShell.separate_in = ""
c.TerminalInteractiveShell.editing_mode = "vi"

# History/search
c.HistoryManager.db_cache_size = 10000

# Autoreload by default
c.InteractiveShellApp.extensions = ["autoreload"]
c.InteractiveShellApp.exec_lines = [
    "%autoreload 2",
]
