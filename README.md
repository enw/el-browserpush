# el-browser-push

## what is it?
push an emacs buffer.
view it in a browser

## how do you use it?
1. run server
```
node el-buffer-server.js
```
2. view page
```
open http://localhost:8889/
```
2. load emacs module
```
(load "~/src/EWApps/el-browserpush/el-push-buffer.el")
```
4. push this buffer to the server
```
M-x el-serve-buffer
```




