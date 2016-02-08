# current-function.vim

This is a simple vim plugin that works out what function you are currently in,
so you can put this in your status bar. When the function is a method on a
class, it concatenates the class name and method name for you.

## Pre-requisites

* exuberant-ctags must be installed and in your path.
* vim must be compiled with python support (`vim --version` should show `+python`)

## Configuration

The plugin proves a function called `GetFunctionUnderCursor`. You can add this
to your status line, e.g.

    set statusline +=%{GetFunctionUnderCursor()}

## Languages

Supports any language that ctags supports. So far has been tested on C, C++ and
python.
