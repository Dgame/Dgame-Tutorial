import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.Graphic;
import Dgame.Math.Vector2;
import Dgame.Math.Rect : Size;

void main() {
    Window wnd = Window(640, 480, "Dgame Test");
    wnd.setVerticalSync(Window.VerticalSync.Enable);
    wnd.setClearColor(Color4b.Green);
    
    Texture wiki_tex = Texture(Surface("samples/images/wiki.png"));
    Sprite wiki = new Sprite(wiki_tex);
    
    int move_x = 4;
    int move_y = 4;

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

        const Vector2f pos = wiki.getPosition();
        const Size wnd_size = wnd.getSize();
        
        if (pos.x + wiki_tex.width >= wnd_size.width || pos.x < 0)
            move_x *= -1;
        if (pos.y + wiki_tex.height >= wnd_size.height || pos.y < 0)
            move_y *= -1;
        
        wiki.move(move_x, move_y);

        wnd.draw(wiki);
        wnd.display();
    }
}