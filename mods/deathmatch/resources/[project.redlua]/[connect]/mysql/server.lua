function Class(tbl)
    setmetatable(tbl, {
        __call = function(cls, ...)
            local self = {}
            setmetatable(self, {
                __index = cls
            })

            self:constructor(...)

            return self
        end
    })

    return tbl
end

local Connection = Class({
    constructor = function(self, args)
        local type, db, host, port, user, pass = unpack(args)
        self.conn = Connection(type ,"dbname="..db..";host="..host..";port="..port..";charset=latin1", user, pass, "autoreconnect=1")
        outputServerLog("[red-owlV2]: | Database : "..db.." | Password : "..pass.."")
        outputServerLog("Basarili bir sekilde navicat (dbConnection) baglantisi yapildi!")
    end;

    dbConn = function(self)
        return self.conn
    end;
})

local hostname = "localhost"
local username = "root"
local password = "123456789" 
local database = "owl" 
local port = 3306

local mysql = Connection({"mysql", database, hostname, port, username, password})
local connection = mysql:dbConn()

function getConnection()
    return connection
end