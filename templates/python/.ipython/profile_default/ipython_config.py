# IPython defaults for this repo
c = get_config()
from pygments.token import Token

# UI/UX
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.autocall = 1
c.TerminalInteractiveShell.separate_in = ""
c.TerminalInteractiveShell.editing_mode = "vi"
c.TerminalInteractiveShell.colors = "neutral"
c.TerminalInteractiveShell.display_completions = "multicolumn"
c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.highlighting_style_overrides = {
    Token.Line: "#f2f4f8",
    Token.Lineno: "#8be9fd",
    Token.LinenoEm: "bold #4ecdc4",
    Token.ExcName: "bold #ff6b6b",
    Token.TB.Name: "#8aa1ff",
    Token.TB.NameEm: "bold #ffd166",
    Token.Caret: "bold #ff6b6b",
}

# History/search
c.HistoryManager.db_cache_size = 10000

# Autoreload by default
c.InteractiveShellApp.extensions = ["autoreload"]
c.InteractiveShellApp.exec_lines = [
    "%autoreload 2",
]
