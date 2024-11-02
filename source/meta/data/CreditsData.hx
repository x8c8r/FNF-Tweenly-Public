package meta.data;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;

typedef CreditsLinks = {
    var twitter:Null<String>;
    var youtube:Null<String>;
    var gamebanana:Null<String>;
}

typedef CreditsEntry = {
    var name:String;
    var links:CreditsLinks;
}

typedef CreditsData = {
    var credits:Array<CreditsEntry>;
}

class Credits {
    public static function load(folder:String):CreditsData {
        try {
            var rawJson = null;

            var creditsPath:String = Paths.mods(folder + '/data/credits.json');
            trace(Paths.mods(folder + '/data/credits.json')); // dont ask me this is fucking stupid
            
            if(FileSystem.exists(creditsPath)) {  
                rawJson = File.getContent(creditsPath).trim();
            }

            if(rawJson == null) {
                #if sys
                rawJson = File.getContent(Paths.modsJson(creditsPath)).trim();
                #else
                rawJson = Assets.getText(Paths.modsJson(creditsPath)).trim();
                #end	
            }

            while (!rawJson.endsWith("}"))
            {
                rawJson = rawJson.substr(0, rawJson.length - 1);
                // LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
            }

            trace(Json.parse(creditsPath));

            var f =cast Json.parse(creditsPath);

            trace('Loaded metadata!');
            trace(f);

            return f;
        }
        catch(e) {
            trace(e);
            return null;
        }
    }
}