" Vim indent file
" Language:         Shell Script
" Maintainer:       Clavelito <maromomo@hotmail.com>
" Id:               $Date: 2013-01-07 10:48:34+09 $
"                   $Revision: 1.8 $


if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetShIndent()
setlocal indentkeys+=0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done
setlocal indentkeys+=0=fin,0=fil,0=fip,0=fir,0=fix
setlocal indentkeys-=:

if exists("*GetShIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function GetShIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  let line = getline(lnum)
  let cline = getline(v:lnum)
  let ind = indent(lnum)
  if line =~ '^\s*#' && cline =~ '^\s*#'
    return ind
  endif

  let [line, lnum] = s:SkipCommentLine(line, lnum, 0)
  let [pline, pnum] = s:SkipCommentLine(line, lnum, 1)
  let ind = indent(lnum)
  let cind = indent(v:lnum)

  let ind = s:MorePrevLineIndent(line, pline, pnum, ind)
  let ind = s:PrevLineIndent(line, lnum, pline, ind)
  let ind = s:CurrentLineIndent(cline, ind, cind)
  let ind = s:InsideHereDocIndent(cline, lnum, ind, cind)

  return ind
endfunction

function s:MorePrevLineIndent(line, pline, pnum, ind)
  let ind = a:ind
  if a:pline !~ '\\$' && a:line =~ '\\$'
    let ind = ind + &sw
  elseif a:pline =~ '\\$' && a:line !~ '\\$'
    let ind = ind - &sw
  elseif a:pline =~ '^\s*IFS=\%(\%o47\|"\)' && a:pline !~ 'IFS=\(\%o47\|"\).*\1'
    let ind = s:EndedIfsLineIndent(a:pline, a:pnum, ind)
  endif

  return ind
endfunction

function s:PrevLineIndent(line, lnum, pline, ind)
  let ind = a:ind
  if a:line =~ '^\s*\%(if\|then\|do\|else\|elif\|while\|until\|for\)\>'
        \ && a:line !~ '\%(fi\|done\)\>\s*\%(#.*\)\=$'
        \ || (a:line =~ '^\s*\<\h\w*\>\s*()\s*{' || a:line =~ '^\s*{')
        \ && a:line !~ '}\s*\%(#.*\)\=$'
        \ || a:line =~ '{\s*\%(#.*\)\=$'
        \ || a:line =~ '|\s*while\>'
    let ind = ind + &sw
  elseif a:line =~ '^\s*case\>' && a:line !~ '\<esac\>'
    let ind = s:PrevLineCaseIndent(ind)
  elseif a:line =~ '^\s*[^(]\+\s*)\s*\%(#.*\)\=$'
        \ && (a:pline =~ '^\s*case\>' || a:pline =~ ';;\s*\%(#.*\)\=$')
    let ind = ind + &sw
  elseif a:line =~ ';;\s*\%(#.*\)\=$' && a:line !~ '^\s*[^(]\+\s*)'
    let ind = ind - &sw
  elseif a:line =~ '^\s*IFS=\%(\%o47\|"\)' && a:line !~ 'IFS=\(\%o47\|"\).*\1'
    let ind = indent(v:lnum)
  elseif a:line =~ '^\s*IFS='
    let ind = s:EndedIfsLineIndent(a:line, a:lnum, ind)
  elseif a:line =~ '^\t*[A-Za-z0-9*-/!%:=?@\[\]^_{}~]\+$'
        \ && a:line !~ '^\t*\%(}\|esac\|echo\|shift\|continue\|break\|exit\)$'
    let [sstr, estr] = s:GetHereDocPairLine1(a:line)
    let ind = s:ClosePairIndent(sstr, estr, a:lnum, ind, 1)
  endif

  return ind
endfunction

function s:CurrentLineIndent(cline, ind, cind)
  let ind = a:ind
  if a:cline =~ '^\s*case\>' && a:cline !~ '\<esac\>'
    let lnum = nextnonblank(v:lnum + 1)
    if lnum > 0
      let s:case_labels_ind = indent(lnum) - indent(v:lnum)
    endif
  elseif a:cline =~ '^\s*\%(then\|do\|else\|elif\|fi\|done\)\>'
        \ || a:cline =~ '^\s*}'
    let ind = ind - &sw
  elseif a:cline =~ '^\s*esac\>'
    let ind = s:ClosePairIndent('^\s*case\>', '^\s*esac\>', v:lnum, ind, 0)
  elseif (a:cline =~ '^\s*#' || a:cline =~ '^\s*IFS=' || a:cline =~ '<<[^-]')
        \ && a:cind == 0
    let ind = 0
  endif

  return ind
endfunction

function s:InsideHereDocIndent(cline, lnum, ind, cind)
  let ind = a:ind
  let lnum = 0
  let onum = 0
  let save_cursor = getpos(".")
  while search('<<-\=\s*\%("\|\%o47\|\\\)\=[A-Za-z0-9*-/!%:=?@\[\]^_{}~]\+' .
        \ '\%("\|\%o47\)\=', 'bW')
    let snum = line(".")
    let [sstr, estr] = s:GetHereDocPairLine2()
    let lnum = searchpair(sstr, '', estr, 'nW')
    if lnum >= get(save_cursor, 1) || lnum < 1 || lnum < onum
      break
    endif
    let onum = lnum
  endwhile
  call setpos('.', save_cursor)
  if lnum >= v:lnum || lnum < 1 && snum
    let ind = a:cind
  endif

  return ind
endfunction

function s:EndedIfsLineIndent(line, lnum, ind)
  let ind = a:ind
  let [line, lnum] = s:SkipCommentLine(a:line, a:lnum, 1)
  let [pline, pnum] = s:SkipCommentLine(line, lnum ,1)
  if lnum > 0
    let ind = indent(lnum)
    let ind = s:MorePrevLineIndent(line, pline, pnum, ind)
    let ind = s:PrevLineIndent(line, lnum, pline, ind)
  endif

  return ind
endfunction

function s:ClosePairIndent(sstr, estr, lnum, ind, prev)
  let ind = a:ind
  let save_cursor = getpos(".")
  call cursor(a:lnum, 1)
  let lnum = searchpair(a:sstr, '', a:estr, 'bW')
  call setpos('.', save_cursor)
  if lnum > 0 && a:prev
    let ind = indent(lnum)
    let line = getline(lnum)
    let [line, lnum] = s:SkipCommentLine(line, lnum, 1)
    let [pline, pnum] = s:SkipCommentLine(line, lnum ,1)
    if lnum > 0
      let ind = indent(lnum)
      let ind = s:MorePrevLineIndent(line, pline, pnum, ind)
      let ind = s:PrevLineIndent(line, lnum, pline, ind)
    endif
  elseif lnum > 0
    let ind = indent(lnum)
  endif

  return ind
endfunction

function s:SkipCommentLine(line, lnum, prev)
  let line = a:line
  let lnum = a:lnum
  while line =~ '^\s*#'
    let lnum = prevnonblank(lnum - 1)
    let line = getline(lnum)
  endwhile
  if a:prev
    let lnum = prevnonblank(lnum - 1)
    let line = getline(lnum)
    while line =~ '^\s*#'
      let lnum = prevnonblank(lnum - 1)
      let line = getline(lnum)
    endwhile
  endif

  return [line, lnum]
endfunction

function s:PrevLineCaseIndent(ind)
  let ind = a:ind
  if exists("g:sh_indent_case_labels") && g:sh_indent_case_labels
    let ind = ind + &sw
  elseif s:case_labels_ind
    let ind = ind + s:case_labels_ind
  endif
  let s:case_labels_ind = 0

  return ind
endfunction

function s:GetHereDocPairLine1(line)
  let estr = matchstr(a:line, '[A-Za-z0-9*-/!%:=?@\[\]^_{}~]\+$')
  let sstr = '<<-\=\s*\%("\|\%o47\|\\\)\=\M' . estr . '\m\%("\|\%o47\)\='
  if a:line =~ '^\t\+'
    let estr = '^\t*\M' . estr . '\m$'
  else
    let estr = '^\M' . estr . '\m$'
  endif

  return [sstr, estr]
endfunction

function s:GetHereDocPairLine2()
  let line = getline(".")
  let estr = substitute(line, '^.*<<-\=\s*\%("\|\%o47\|\\\)\=', '', '')
  let estr = substitute(estr,
        \ '^\([A-Za-z0-9*-/!%:=?@\[\]^_{}~]\+\)\%("\|\%o47\)\=.*$', '\1', '')
  if line =~ '<<-'
    let sstr = '<<-\=\s*\%("\|\%o47\|\\\)\=\M' . estr . '\m\%("\|\%o47\)\='
    let estr = '^\t*\M' . estr . '\m$'
  else
    let sstr = '<<\s*\%("\|\%o47\|\\\)\=\M' . estr . '\m\%("\|\%o47\)\='
    let estr = '^\M' . estr . '\m$'
  endif

  return [sstr, estr]
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set sts=2 sw=2 expandtab:
