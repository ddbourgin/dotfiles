# overview of config options:
# http://ipython.org/ipython-doc/dev/config/index.html

# get the root config object
c = get_config()

#####################################
#      Startup Configuration
#####################################
# Use powerline
# c.InteractiveShellApp.extensions = [
#     'powerline.bindings.ipython.post_0_11'
# ]

# Whether to display a banner upon starting IPython.
c.TerminalIPythonApp.display_banner = False

# lines of code to execute on startup
c.InteractiveShellApp.exec_lines = [
    'import numpy as np'
]

# files to be run on startup
# c.InteractiveShellApp.exec_files = [
#     'mycode.py',
#     'fancy.ipy'
# ]

#####################################
#  Interactive Shell Configuration
#####################################

# Autoindent IPython code entered interactively.
c.InteractiveShell.autoindent = True

# Set the color scheme (NoColor, Linux, or LightBG).
c.InteractiveShell.colors = 'Linux'

# Confirm when you try to exit IPython with an EOF (Control-D in Unix)
c.InteractiveShell.confirm_exit = False

# Enable deep (recursive) reloading by default. IPython can use the deep_reload
# module which reloads changes in modules recursively (it replaces the reload()
# function, so you don't need to change anything to use it). deep_reload()
# forces a full reload of modules whose code may have changed, which the default
# reload() function does not. When deep_reload is off, IPython will use the
# normal reload(), but deep_reload will still be available as dreload().
c.InteractiveShell.deep_reload = True

# Set the editor used by IPython (default to $EDITOR/vi/notepad).
c.InteractiveShell.editor = 'vim'

# Call the pdb debugger after every exception.
c.TerminalInteractiveShell.pdb = False

#####################################
#        Prompt Configuration
#####################################
# setting terminal colors:
# http://ipython.org/ipython-doc/dev/config/details.html#terminal-colors

# Input prompt. '#' is transformed to the prompt number
c.PromptManager.in_template  = '{color.LightPurple}{cwd_last} {color.Yellow}[\#]: '

# Input continuation prompt.
c.PromptManager.in2_template = '   {color.Yellow}... '

# Output prompt. '#' is transformed to the prompt number
c.PromptManager.out_template = ''

c.PrefilterManager.multi_line_specials = False
