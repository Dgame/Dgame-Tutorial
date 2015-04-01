import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.Graphic;
import Dgame.Math.Rect;
import Dgame.Audio.Sound;

void main() {
    Window wnd = Window(640, 480, "Dgame Test");
    wnd.setVerticalSync(Window.VerticalSync.Enable);
    wnd.setClearColor(Color4b.Black);

    Surface explo_img = Surface("samples/images/explosion.png");
    Texture explo_tex = Texture(explo_img);

    Spritesheet explosion = new Spritesheet(explo_tex, Rect(0, 0, 256, 256));

    Sound explosion_sound = Sound("samples/audio/expl.wav");
    explosion_sound.setVolume(50);

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

                case Event.Type.KeyDown:
                    explosion_sound.play();
                    writefln("Volume: %d", explosion_sound.getVolume());
                    break;
                    
                    
                default: break;
            }
        }
        
        explosion.slideTextureRect();
        
        wnd.draw(explosion);
        
        wnd.display();
    }
}