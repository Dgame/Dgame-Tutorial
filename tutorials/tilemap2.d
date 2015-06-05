import std.stdio;

import Dgame.Window;
import Dgame.Graphic;
import Dgame.Math;
import Dgame.System;

enum ubyte MAP_WIDTH = 12;
enum ubyte MAP_HEIGHT = 10;

enum ubyte TILE_SIZE = 32;
enum ubyte MOVE = TILE_SIZE;
enum ubyte ROTATION = 90;
enum ubyte GRAVITY = TILE_SIZE / 4;

enum ubyte MAX_FPS = 60;
enum ubyte TICKS_PER_FRAME = 1000 / MAX_FPS;

@nogc
bool isWalkable(const Sprite[] tiles, Sprite player) pure nothrow {
    const Vector2i edge_pos = player.getClipRect().getEdgePosition(Rect.Edge.BottomLeft);
    const Vector2f pos = edge_pos;

    foreach (const Sprite tile; tiles) {
        if (tile.getPosition() == pos)
            return true;
    }

    return false;
}

@nogc
bool gravityEffect(const Sprite[] tiles, Sprite player) pure nothrow {
    if (!isWalkable(tiles, player)) {
        player.move(0, GRAVITY);

        return true;
    }

    return false;
}

void main() {
    Window wnd = Window(MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE, "Dgame Test");

    // 0 = empty, a = start, t = (walkable) tile, b = brittle tile, z = target
    const char[MAP_WIDTH * MAP_HEIGHT] Tiles = [
        '0', 'a', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
        '0', 't', 't', 't', 't', 't', '0', '0', 't', 't', 't', '0',
        '0', '0', '0', 't', 't', 't', 't', '0', '0', '0', '0', '0',
        '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
        't', 't', '0', '0', '0', '0', 't', 't', 't', 't', '0', 't',
        '0', '0', '0', '0', '0', 't', 't', 't', '0', '0', 't', 't',
        '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
        '0', 't', 't', 't', 't', '0', '0', '0', '0', '0', '0', '0',
        '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'z',
        '0', '0', '0', 't', 't', 't', 't', 't', 't', 't', 't', 't',
    ];

    Texture player_tex = Texture(Surface("Basti-Box.png"));
    Texture tile_tex = Texture(Surface("Tile.png"));

    Vector2f start, target;

    Sprite[] tiles;

    ubyte x, y;
    foreach (ubyte idx, char c; Tiles) {
        if (Tiles[idx] == 't')
            tiles ~= new Sprite(tile_tex, Vector2f(x * TILE_SIZE, y * TILE_SIZE));
        else if (Tiles[idx] == 'a')
            start = Vector2f(x * TILE_SIZE, y * TILE_SIZE);
        else if (Tiles[idx] == 'z')
            target = Vector2f(x * TILE_SIZE, y * TILE_SIZE);

        x++;
        if (x >= MAP_WIDTH) {
            x = 0;
            y++;
        }
    }

    Spritesheet player = new Spritesheet(player_tex, Rect(0, 0, 32, 32));
    player.setPosition(start);
    player.setRotationCenter(16, 16);

    Font fnt = Font("samples/font/arial.ttf", 12);
    Text fps = new Text(fnt);
    fps.setPosition(MAP_WIDTH * TILE_SIZE - 96, 4);

    StopWatch sw;
    StopWatch sw_fps;

    bool running = true;

    Event event;
    while (running) {
        wnd.clear();

        fps.format("FPS: %d", sw_fps.getCurrentFPS());

        if (sw.getElapsedTicks() > TICKS_PER_FRAME) {
            sw.reset();

            const bool gravity = gravityEffect(tiles, player);
            
            while (wnd.poll(&event)) {
                switch (event.type) {
                    case Event.Type.Quit:
                        writeln("Quit Event");
                        running = false;
                    break;
                        
                    case Event.Type.KeyDown:
                        writeln("Pressed key ", event.keyboard.key);
                        
                        if (event.keyboard.key == Keyboard.Key.Esc)
                            running = false;
                        else if (!gravity) {
                            switch (event.keyboard.key) {
                                case Keyboard.Key.Left:
                                    player.move(MOVE * -1, 0);
                                    player.rotate(ROTATION * -1);
                                    writeln(player.getRotation());
                                    player.selectFrame(0);
                                break;
                                case Keyboard.Key.Right:
                                    player.move(MOVE, 0);
                                    player.rotate(ROTATION);
                                    writeln(player.getRotation());
                                    player.selectFrame(1);
                                break;
                                default: break;
                            }
                        }
                    break;
                        
                    default: break;
                }
            }

            if (player.getPosition() == target) {
                wnd.push(Event.Type.Quit);
                writeln("You've won!");
            } else {
                const Vector2f pos = player.getPosition();
                if (pos.x > (MAP_WIDTH * TILE_SIZE) ||
                    pos.x < 0 ||
                    pos.y > (MAP_HEIGHT * TILE_SIZE) ||
                    pos.y < 0)
                {
                    writeln("You've lost!");
                    wnd.push(Event.Type.Quit);
                }
            }
        }

        wnd.draw(fps);

        foreach (Sprite tile; tiles) {
            wnd.draw(tile);
        }

        wnd.draw(player);

        wnd.display();
    }
}