function! IndexFile()
python << EOF
import vim, os, re, subprocess
tags = subprocess.check_output([
  'ctags',
  '--options=NONE',
  '-o',
  '-',
  '-n',
  '--sort=no',
  vim.eval("expand('%:p')"),
], stderr=open('/dev/null', 'w'))
table = []

tagline_regex = re.compile(r'([^\t]*)\t([^\t]*)\t(\d+);"\t([^\t]*)\t?(.*)?')
class_regex = re.compile(r'class:([^ \t]+)')

for t in tags.split("\n"):
  m = tagline_regex.match(t)
  if m:
    if m.group(4) == "f" or m.group(4) == "m":
      l = int(m.group(3))

      class_match = class_regex.search(m.group(5))
      if class_match:
        name = class_match.group(1) + "::" + m.group(1)
      else:
        name = m.group(1)

      table.append((l, name))

table_str = ",".join("%s,%s" % (t[0], t[1]) for t in table)
vim.command("let b:tags = '%s'" % table_str)
EOF
endfunction

function! GetFunctionUnderCursor()
  let name = GetFunctionName(line("."))
  return name
endfunction

function! GetFunctionName(curline)
  if !exists("b:tags")
    return ''
  endif
python << EOF
import vim

line = int(vim.eval("a:curline"))
table_str = vim.eval("b:tags")
found = ''

if table_str:
  table_iter = table_str.split(',')
  table = zip(map(int, table_iter[::2]), table_iter[1::2])

  for ix in xrange(len(table)):
    if line >= table[ix][0]:

      if (ix+1 >= len(table)) or (line < table[ix+1][0]):
        found = table[ix][1]
        break

vim.command("let name = '%s'" % found)
EOF

return name
endfunction

autocmd BufWritePost * call IndexFile()
autocmd BufReadPre * call IndexFile()
