deletefiles =
{ "plaka.png",
"plaka_devlet.png",
"plaka_polis.png",}

function onStartResourceDeleteFiles()
for i=1, #deletefiles do
fileDelete(deletefiles[i])
end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), onStartResourceDeleteFiles)

function onPlayerQuit()
for i=1, #deletefiles do
fileDelete(deletefiles[i])
end
end
addEventHandler("onClientPlayerQuit", getResourceRootElement(getThisResource()), onPlayerQuit)
