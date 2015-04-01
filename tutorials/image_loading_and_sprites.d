import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.Graphic;

void main() {
    Window wnd = Window(640, 480, "Dgame Test");
    wnd.setClearColor(Color4b.Green);
    
    Surface wiki_img = Surface("samples/images/wiki.png");
    wiki_img.saveToFile("samples/images/wiki_clone.png");
    Texture wiki_tex = Texture(wiki_img);
    
    Sprite wiki = new Sprite(wiki_tex);
    wiki.setPosition(50, 100);

    bool running = true;
    
    Event event;
    while (running) {
        wnd.clear();
        
        while (wnd.poll(&event)) {
            switch (event.type) {
                case Event.Type.Quit:
                    writeln("Quit Event");
                    
                    running = false;
                    break;
                    
                default: break;
            }
        }
        
        wnd.draw(wiki);
        
        wnd.display();
    }
}