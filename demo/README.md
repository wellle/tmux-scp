# Demo hosts

Two throwaway hosts in Docker, to try tmux-scp without real servers or to
record the README's demo:

| Pane | Host | User | Directory |
|------|------|------|-----------|
| top | `web-01` | `deploy` | `~/exports` |
| bottom | `analytics-warehouse` | `data_pipeline` | `~/imports` |

They listen on `127.0.0.1:2221` and `:2222` and use their own ssh key and
config in `demo/.state`, through `demo/bin/ssh`. Your `~/.ssh/config`, your
tmux server and your own yank are left alone: the demo runs a separate tmux
server with tmux's default keys plus the plugin.

## Use

```
demo/setup.sh    # build and start the hosts (once, or to rebuild)
demo/start.sh    # start the demo tmux and attach
demo/stop.sh     # stop the demo tmux and remove the containers
```

`start.sh` resets the files on both hosts every time, so each run starts
from the same state. Run it in a terminal outside tmux.

## Recording the README demo

Setup:

1. Open a new terminal window, not inside tmux. Make the font large (the
   popup has to be readable at 900 px wide) and the window about 110 x 32.
2. Turn off keystroke overlays like KeyCastr: the keys are added afterwards,
   in the caption strip.
3. Run `demo/start.sh`. The top pane shows `deploy@web-01 ~/exports $` and
   its files, the bottom one `data_pipeline@analytics-warehouse ~/imports $`.
4. Start the screen recording on the terminal window.

The take, with pauses so each step can be read:

| # | Do | Then wait |
|---|----|-----------|
| 1 | nothing | 1 s |
| 2 | type `ls ord`, press Tab (`ls orders-2026-09.csv`), no Enter | 1 s |
| 3 | `C-b C-y` to yank | 2 s, the yank message shows |
| 4 | `C-b o` to switch to the bottom pane | 1 s |
| 5 | `C-b C-p` to put | 4 s, to read the popup |
| 6 | `y` to confirm | until the popup has closed |
| 7 | type `ls -lhtr`, Enter | 3 s, the file is there |

Stop the recording. For another take, detach with `C-b d` and run
`demo/start.sh` again.
