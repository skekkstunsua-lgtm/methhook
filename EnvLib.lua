

local EnvLib = {};
local env = getfenv()


--#region resolving



EnvLib.functions = {
    newcclosure = {"newcclosure"};
    newlclosure = {"newlclosure"};
    islclosure = {"islclosure"};
    iscclosure = {"iscclosure"};
    clonefunction = {"clonefunction"};
    isexecutorclosure = {"isexecutorclosure"; "issynapsefunction"};
    getnamecallmethod = {"getnamecallmethod"};
    getcallingscript = {"getcallingscript"};
    getloadedmodules = {"getloadedmodules"};
    getscripts = {"getscripts"};
    getscripthash = {"getscripthash"};
    getfunctionhash = {"getfunctionhash"};
    getscriptname = {"getscriptname"};
    run_on_actor = {"run_on_actor"; "runonactor"; "syn.run_on_actor"};
    setthreadidentity = {"setthreadidentity"; "set_thread_identity"; "syn.set_thread_identity"};
    getthreadidentity = {"getthreadidentity"; "get_thread_identity"; "syn.get_thread_identity"};
    getconnections = {"getconnections"};
    firesignal = {"firesignal"};
    cfiresignal = {"cfiresignal"};
    replicatesignal = {"replicatesignal"};
    cansignalreplicate = {"cansignalreplicate"};
    getsignalarguments = {"getsignalarguments"};
    hooksignal = {"hooksignal"};
    restoresignal = {"restoresignal"};
    issignalhooked = {"issignalhooked"};
    isconnectionenabled = {"isconnectionenabled"};
    isluaconnection = {"isluaconnection"};
    iswaitingconnection = {"iswaitingconnection"};
    getconnectionfunction = {"getconnectionfunction"};
    isgamescriptconnection = {"isgamescriptconnection"};
    gethui = {"gethui"};
    getupvalue = {"getupvalue"; "debug.getupvalue"};
    getupvalues = {"getupvalues"; "debug.getupvalues"};
    hookfunction = {"hookfunction"};
    hookmetamethod = {"hookmetamethod"};
    isrenderobj = {"isrenderobj"; "Drawing.isrenderobj"};
    cleardrawcache = {"cleardrawcache"; "Drawing.clear"; "Drawing.clearall"};
    getrenderproperty = {"getrenderproperty"; "Drawing.getrenderproperty"};
    setrenderproperty = {"setrenderproperty"; "Drawing.setrenderproperty"};
};

resolvePath = function(opt, tbl)
    local parts = string.split(opt, '.')
    local target = tbl

    for _, part in ipairs(parts) do 
        target = target and target[part]
    end;

    if type(target) == 'function' then 
        return target
    end;

    return
end;

resolveFont = function(name)
    local fonts = Drawing and Drawing.Fonts

    if fonts and fonts[name] then 
        return fonts[name]
    end;

    local fallbacks = {
        UI = 0;
        System = 1;
        Plex = 2;
        Monospace = 3;
    };

    return fallbacks[name]
end;

--If supported executor uses aliases for funcs. gets a function using its name


EnvLib.GetFunction = function(name, name2) -- returns func or nil.
    name = tostring(name):lower()

    local resolvednames = EnvLib.functions[name]

    if not resolvednames then 
        return nil
    end;

    for _, resolved in ipairs(resolvednames) do 
        local fn = resolvePath(resolved, env)

        if fn then 
            return fn
        end;
    end;
end;

EnvLib.Drawing.Fonts = setmetatable({}, {
    __index = function(_, key)
        return resolveFont(key)
    end;
})

EnvLib.Drawing.new = function(type)
    return Drawing.new(type)
end;

EnvLib.Drawing.clear = function()
    local fn = EnvLib.GetFunction("cleardrawcache")

    if fn then 
        fn()
        return
    end;
end;

EnvLib.Drawing.isRenderObj = function(obj)
    local fn = EnvLib.GetFunction("isrenderobj")

    if fn then 
        return fn(obj)
    end;


    return typeof(obj) == "userdata"
end;

--[[

-- FONT USAGE !!!



local Fonts = EnvLib.Drawing.Fonts

local line = EnvLib.Drawing.new("Line")




-- GETFUNCTION USE EXAMPLE !!!

local setthreadidentity = EnvLib:GetFunction("setthreadidentity")
local hookfunction = EnvLib:GetFunction("hookfunction")



]]


--#endregion


return EnvLib
