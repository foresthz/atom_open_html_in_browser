{exec} = require 'child_process'
Shell = require 'shell'
fs = require 'fs'
path = require 'path'
{CompositeDisposable} = require 'atom'

chrome='"C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"'
chromium_tmp_65='E:/Tools/chrome-win32_65_tmp/chrome_65.exe --user-data-dir="E:/ChromeData/MyData65"'

# E:\Tools\chrome-win32_65_tmp\chrome_65.exe --user-data-dir="E:\ChromeData\MyData65"

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.commands.add('atom-text-editor[data-grammar~="js"]',
      'open-html-in-browser:open': ({target}) =>
        @open(target.getModel().getPath())
    ))

    # what is the meaning of the following syntax?
    @subscriptions.add(atom.commands.add('.tree-view',
      'open-html-in-browser:selected-entry': ({currentTarget: target}) =>
        entry =  target?.querySelector('.selected .name')
        filePath = entry?.dataset.path
        #return unless filePath?.endsWith('.html')
        #alert(filePath)
        console.log "ok"
        console.log "output to console"
        fs.stat filePath, (err, stats) ->
          if stats.isDirectory()
            console.log "in the folder"
            # use &, not &&
            # wrong position of comma cannot start cli
            # path.dirname(filePath) of directory is its parent folder
            gitpath= 'C:/GitHome/cygwin/bin;C:/GitHome/win/xbin;D:/Tools/Atom Beta/resources/app/apm/bin;'
            gitCMD = " & set githome=" + gitpath + " & set Path="+gitpath+"%Path%;"
            cmdstr = " " + filePath.substring(0,2) + " & cd  " + filePath + gitCMD + " & start"
            execstr = 'cmd /c "' + cmdstr + '"'
            console.log "execstr: ", execstr
            console.log "dirname: ", path.dirname filePath
            exec execstr
            #_this.open(filePath)
          else
            console.log "the file is selected"
            console.log 'chromecmd: ', chromium_tmp_65

            # how this _this should be generater?
            _this.open(filePath)
          #return
        # why is translated to _this.open rather than this.open?
        #@open(filePath)

    ))

  deactivate: ->
    @subscriptions.dispose()

  open: (filePath) ->
    switch process.platform
      when 'darwin'
        exec("open '#{filePath}'")
      when 'linux'
        exec("xdg-open '#{filePath}'")
      when 'win32'
        cmdstr = chromium_tmp_65 + ' "' + "file:///#{filePath}" + '"'
        #alert(cmdstr)
        exec(cmdstr)
        #Shell.openExternal("file:///#{filePath}")
