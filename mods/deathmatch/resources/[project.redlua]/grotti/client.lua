-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- DİSCORD : https://discord.gg/DzgEcvy 

txd = engineLoadTXD ('MPG_8.txd') 
engineImportTXD (txd, 14876) 
dff = engineLoadDFF('MPG_1.dff', 14876) 
engineReplaceModel (dff, 14876)
txd = engineLoadTXD ('MPG_8.txd') 
engineImportTXD (txd, 5660) 
dff = engineLoadDFF('MPG_2.dff', 5660) 
engineReplaceModel (dff, 5660)
col = engineLoadCOL ('MPG_1.col')
engineReplaceCOL (col, 14876)
col = engineLoadCOL ('MPG_2.col')
engineReplaceCOL (col, 5660)



txd = engineLoadTXD ('MPG_8.txd') 
engineImportTXD (txd, 4594) 
dff = engineLoadDFF('MPG_8.dff', 4594) 
engineReplaceModel (dff, 4594)
col = engineLoadCOL ('MPG_8.col')
engineReplaceCOL (col, 4594)
engineSetModelLODDistance(4594,1000)

-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- DİSCORD : https://discord.gg/DzgEcvy 