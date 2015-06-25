"============================================================================
"File:        dub.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Alfredo Di Napoli
"License:     Based on the original work of Gregor Uhlenheuer and his
"             cpp.vim checker so credits are dued.
"             THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"             EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
"             OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
"             NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
"             HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
"             WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
"             FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
"             OTHER DEALINGS IN THE SOFTWARE.
"
"============================================================================

if exists('g:loaded_syntastic_d_dmd_checker')
	finish
endif
let g:loaded_syntastic_d_dub_checker = 1

if !exists('g:syntastic_d_compiler_options')
	let g:syntastic_d_compiler_options = ''
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_d_dub_IsAvailable() dict
	if !exists('g:syntastic_d_compiler')
		let g:syntastic_d_compiler = self.getExec()
	endif
	call self.log('g:syntastic_d_compiler =', g:syntastic_d_compiler)
	return executable(expand(g:syntastic_d_compiler, 1))
endfunction

function! SyntaxCheckers_d_dub_GetLocList() dict
    if !exists('g:syntastic_d_include_dirs')
        let g:syntastic_d_include_dirs = filter(glob($HOME . '/.dub/packages/*', 1, 1), 'isdirectory(v:val)')
        call map(g:syntastic_d_include_dirs, 'isdirectory(v:val . "/source") ? v:val . "/source" : v:val')
        call add(g:syntastic_d_include_dirs, './source')
    endif

    let makeprg = self.makeprgBuild({
        \ 'exe': 'dub',
        \ 'fname':'',
        \ 'args': 'build --build unittest'})
    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat':
        \     '%-G%f:%s:,' .
        \     '%f(%l): %m,' .
        \     '%f(%l\,%c): %m,' .
        \     '%f:%l: %m',
        \ 'header_names': '\m\.di$' })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
\ 'filetype': 'd',
\ 'name': 'dub' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:

