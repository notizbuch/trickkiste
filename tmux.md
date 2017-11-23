#### create 2x2 grid and execute command in each

```
#!/bin/sh

tmux new -s mysession1 -d
tmux rename-window 'mywindow'
tmux select-window -t mysession1:0
tmux split-window -h
tmux split-window -v -t 0
tmux split-window -v -t 1

tmux send-keys -t mysession1:0.0 'a' C-m
tmux send-keys -t mysession1:0.1 'b' C-m
tmux send-keys -t mysession1:0.2 'c' C-m
tmux send-keys -t mysession1:0.3 'd' C-m

tmux setw synchronize-panes on

tmux attach -t mysession1
```
