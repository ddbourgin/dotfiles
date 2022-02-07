# this is loaded within .vimrc to ensure YCM uses locally installed versions of
# documentation and packages within a virtualenv.
#
# https://github.com/ycm-core/YouCompleteMe#configuring-through-vim-options
def Settings(**kwargs):
    client_data = kwargs["client_data"]
    return {
        "interpreter_path": client_data["g:ycm_python_interpreter_path"],
        "sys_path": client_data["g:ycm_python_sys_path"],
    }
