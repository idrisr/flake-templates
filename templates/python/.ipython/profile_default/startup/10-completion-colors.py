from IPython import get_ipython
from IPython.terminal.interactiveshell import theme_table
from prompt_toolkit.styles import Style, merge_styles
from pygments.formatters import Terminal256Formatter
from pygments.token import Token


COMPLETION_STYLE = Style.from_dict(
    {
        "completion-menu": "bg:#1c1f2a #e6eaf2",
        "completion-menu.completion.current": "bg:#ffffff #000000 bold noreverse",
        "completion-menu.completion.current fuzzymatch.outside": "#000000",
        "completion-menu.completion.current fuzzymatch.inside": "#000000 bold",
        "completion-menu.completion.current fuzzymatch.inside.character": "#000000 bold underline",
        "completion-menu.meta.completion": "bg:#262b38 #aeb8cc",
        "completion-menu.meta.completion.current": "bg:#ffffff #000000 bold noreverse",
        "completion-toolbar": "bg:#1c1f2a #e6eaf2",
        "completion-toolbar.completion.current": "bg:#ffffff #000000 bold noreverse",
        "readline-like-completions.completion": "#9fb2d6",
    }
)


TRACEBACK_STYLE_OVERRIDES = {
    Token.Line: "#f2f4f8",
    Token.Lineno: "#8be9fd",
    Token.LinenoEm: "bold #4ecdc4",
    Token.ExcName: "bold #ff6b6b",
    Token.TB.Name: "#8aa1ff",
    Token.TB.NameEm: "bold #ffd166",
    Token.Caret: "bold #ff6b6b",
    Token.Literal.String: "#7dcfff",
    Token.Literal.String.Double: "#7dcfff",
    Token.Literal.String.Single: "#7dcfff",
    Token.Literal.String.Affix: "#7dcfff",
    Token.Literal.String.Interpol: "bold #a78bfa",
}


def apply_completion_style():
    shell = get_ipython()
    if shell is None:
        return

    if getattr(shell, "_completion_style_applied", False):
        return

    pt_session = getattr(shell, "pt_app", None)
    if pt_session is None:
        return

    app = getattr(pt_session, "app", None)
    if app is None:
        return

    app.style = merge_styles([app.style, COMPLETION_STYLE])
    shell._completion_style_applied = True


def apply_traceback_style():
    shell = get_ipython()
    if shell is None:
        return

    tb = getattr(shell, "InteractiveTB", None)
    if tb is None:
        return

    tb.tb_highlight = "bold"

    theme = theme_table.get(shell.colors.lower())
    if theme is None:
        return

    theme.extra_style.update(TRACEBACK_STYLE_OVERRIDES)
    theme.as_pygments_style.cache_clear()
    theme._formatter = Terminal256Formatter(style=theme.as_pygments_style())


def _apply_completion_style_lazily(*_args, **_kwargs):
    apply_completion_style()


apply_completion_style()
apply_traceback_style()
shell = get_ipython()
if shell is not None:
    shell.events.register("shell_initialized", _apply_completion_style_lazily)
    shell.events.register("pre_run_cell", _apply_completion_style_lazily)
