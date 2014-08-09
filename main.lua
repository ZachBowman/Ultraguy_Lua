-- Ultraguy
-- Nightmare Games
-- 2014

function love.load()
  key_down = false;
  key_left = false;
  key_right = false;
  key_x = false;

  tilesize = 80;

  -- replace ultraguy and methhead types with universal guy type
  guy_type = {};  -- ultra, methhead
  guy_x = {};
  guy_y = {};
  guy_x_velocity = {};
  guy_y_velocity = {};
  guy_health = {};
  guy_direction = {};
  guy_state = {};
  guy_on_ground = {};
  guy_blinking = {};
  guy_jumpheight = {};
  total_guys = 0;
  ultra = 0;  -- ultraguy index

  tile_x = {};
  tile_y = {};
  tile_type = {};
  for t = 1, 50 do
    tile_x[t] = 0;
    tile_y[t] = 0;
    tile_type[t] = '.';
  end
  total_tiles = 0;

  level1a = {"................",
             "................",
             "................",
             "................",
             "................",
             "bb.U............",
             "bb....bbb..M....",
             "ssssssssssssssss",
             "................"};

  level_width = 16;
  level_height = 9;

  for my = 1, level_height do
    for mx = 1, level_width do
      if string.sub (level1a[my], mx, mx) == 'b' 
      or string.sub (level1a[my], mx, mx) == 'd' 
      or string.sub (level1a[my], mx, mx) == 's' then
        total_tiles = total_tiles + 1;
        tile_x[total_tiles] = (mx - 1) * tilesize;
        tile_y[total_tiles] = my * tilesize;
        tile_type[total_tiles] = string.sub (level1a[my], mx, mx);

      elseif string.sub (level1a[my], mx, mx) == 'U' then
        guy_type[ultra] = "ultra";
        guy_x[ultra] = (mx - 1) * tilesize;
        guy_y[ultra] = (my - 2) * tilesize;
        guy_x_velocity[ultra] = 0;
        guy_y_velocity[ultra] = 0;
        guy_health[ultra] = 100;
        guy_direction[ultra] = "right";
        guy_state[ultra] = "standing";
        guy_on_ground[ultra] = false;
        guy_blinking[ultra] = false;
        guy_jumpheight[ultra] = 0;

      elseif string.sub (level1a[my], mx, mx) == 'M' then
        total_guys = total_guys + 1;
        guy_type[total_guys] = "methhead";
        guy_x[total_guys] = (mx - 1) * tilesize;
        guy_y[total_guys] = (my - 2) * tilesize;
        guy_x_velocity[total_guys] = 0;
        guy_y_velocity[total_guys] = 0;
        guy_health[total_guys] = 100;
        guy_direction[total_guys] = "left";
        guy_state[total_guys] = "standing";
      end
    end
  end

  love.graphics.setDefaultFilter("nearest", "nearest");

  ultraguy_sprite = love.graphics.newImage ("images/ultraguy.png");
  ultraguy_standing_right = love.graphics.newQuad  (0,  0, 30, 40, 400, 400);
  ultraguy_blinking_right = love.graphics.newQuad (31,  0, 30, 40, 400, 400);
  ultraguy_standing_left  = love.graphics.newQuad  (0, 41, 30, 40, 400, 400);
  ultraguy_blinking_left  = love.graphics.newQuad (31, 41, 30, 40, 400, 400);

  people_sprite = love.graphics.newImage ("images/people.png");
  guy_idle_left     = love.graphics.newQuad  (0, 41, 30, 40, 400, 400);
  guy_standing_left = love.graphics.newQuad (31, 41, 30, 40, 400, 400);

  tile_sprite   = love.graphics.newImage ("images/tiles.png");
  tile_brick    = love.graphics.newQuad  (0, 0, 20, 20, 320, 200);
  tile_sidewalk = love.graphics.newQuad (21, 0, 20, 20, 320, 200);
  tile_dirt     = love.graphics.newQuad (42, 0, 20, 20, 320, 200);
end

------------------------------------------------------------------------

function love.update (dt)

  keyboard_input();

  -- Update Guys
  -- FINISH UPDATING TO USE LOOP FOR ALL GUYS

  for g = 1, total_guys do

    -- MOVE ON X
    guy_x[g] = guy_x[g] + guy_x_velocity[g];

  if ultra_x < 0 then                     -- off left of screen
    ultra_x = 0;
  end
  if ultra_x + tilesize - 10 > 1024 then  -- off right of screen
    ultra_x = 1024 - tilesize + 10;
  end

  t = ultra_tile_collision();
  if t > 0 and ultra_x_velocity < 0 then      -- hit tile on left
    ultra_x = tile_x[t] + tilesize - 10;
  elseif t > 0 and ultra_x_velocity > 0 then  -- hit tile on right
    ultra_x = tile_x[t] - tilesize + 10;
  end

  -- MOVE ON Y
  if ultra_y_velocity < 8 then                 -- max speed of gravity
    ultra_y_velocity = ultra_y_velocity + .7;  -- downward acceleration of gravity
  end
  if ultra_y_velocity < 0 then
    ultra_jumpheight = ultra_jumpheight - ultra_y_velocity;  -- add up total height of jump so far
  end
  ultra_y = ultra_y + ultra_y_velocity;

  t = ultra_tile_collision();

  if t > 0 and ultra_y_velocity < 0 then      -- hit a tile above
    ultra_y = tile_t[t] + (tilesize / 2);

  elseif t > 0 and ultra_y_velocity > 0 then  -- hit a tile below
    ultra_y = tile_y[t] - (tilesize * 2);
    ultra_on_ground = true;
    if ultra_state == "jumping" then
      ultra_state = "standing";
    end
  end

  if ultra_state == "standing" then
    if ultra_blinking == false and math.random (200) == 1 then
      ultra_blinking = true;
    elseif ultra_blinking == true and math.random (20) == 1 then
      ultra_blinking = false;
    end
  end
  end

end

------------------------------------------------------------------------

function keyboard_input ()

  -- LEFT
  if love.keyboard.isDown ("left") and key_left == false then
    ultra_x_velocity = ultra_x_velocity - 2;
    key_left = true;
  end;

  if love.keyboard.isDown ("left") == false and key_left == true then
    ultra_x_velocity = ultra_x_velocity + 2;
    key_left = false;
  end;

  -- RIGHT
  if love.keyboard.isDown ("right") and key_right == false then
    ultra_x_velocity = ultra_x_velocity + 2;
    key_right = true;
  end;

  if love.keyboard.isDown ("right") == false and key_right == true then
    ultra_x_velocity = ultra_x_velocity - 2;
    key_right = false;
  end;

  -- FACING DIRECTION
  if love.keyboard.isDown ("right") then
    ultra_direction = "right";
  elseif love.keyboard.isDown ("left") then
    ultra_direction = "left";
  end;

  if love.keyboard.isDown ("c") then
  end;

  -- JUMP
  if love.keyboard.isDown ("x") and ultra_state == "jumping" and ultra_jumpheight < tilesize * 1.7 then
    ultra_y_velocity = -10;
  end

  if love.keyboard.isDown ("x") and key_x == false then
    if ultra_on_ground == true then
      ultra_y_velocity = -10;
      ultra_on_ground = false;
      ultra_state = "jumping";
      ultra_jumpheight = 0;
    end
    key_x = true;
  end

  if love.keyboard.isDown ("x") == false and key_x == true then
    key_x = false;
  end;

end

------------------------------------------------------------------------

function ultra_tile_collision ()
  for t = 1, total_tiles do
    if ultra_x + tilesize - 10 > tile_x[t] and ultra_x + 10 < tile_x[t] + tilesize
      and ultra_y + (tilesize * 2) > tile_y[t] and ultra_y + (tilesize / 2) < tile_y[t] + tilesize then
      return t;
    end
  end
  return 0;
end

------------------------------------------------------------------------

function love.draw ()
  -- Sky
  love.graphics.setColor (0, 203, 255, 255);
  love.graphics.rectangle ("fill", 0, 0, 1024, 688);
  love.graphics.setColor (255, 255, 255, 255);

  for t = 0, total_tiles do
    if tile_type[t] == 'b' then
      love.graphics.draw (tile_sprite, tile_brick,    tile_x[t], tile_y[t], 0, 4, 4);
    elseif tile_type[t] == 'd' then
      love.graphics.draw (tile_sprite, tile_dirt,     tile_x[t], tile_y[t], 0, 4, 4);
    elseif tile_type[t] == 's' then
      love.graphics.draw (tile_sprite, tile_sidewalk, tile_x[t], tile_y[t], 0, 4, 4);
    end
  end

  -- Meth Heads
  for m = 0, total_guys do
    if guy_direction[m] == "right" then
      love.graphics.draw (people_sprite, guy_standing_right, guy_x[m] - 20, guy_y[m], 0, 4, 4);
    elseif guy_direction[m] == "left" then
      love.graphics.draw (people_sprite, guy_standing_left,  guy_x[m] - 20, guy_y[m], 0, 4, 4);
    end
  end

  -- Ultraguy
  if ultra_direction == "right" then
    love.graphics.draw (ultraguy_sprite, ultraguy_standing_right, ultra_x - 20, ultra_y, 0, 4, 4);
    if ultra_blinking == true then
      love.graphics.draw (ultraguy_sprite, ultraguy_blinking_right, ultra_x - 20, ultra_y, 0, 4, 4);
    end
  elseif ultra_direction == "left" then
    love.graphics.draw (ultraguy_sprite, ultraguy_standing_left,  ultra_x - 20, ultra_y, 0, 4, 4);
    if ultra_blinking == true then
      love.graphics.draw (ultraguy_sprite, ultraguy_blinking_left, ultra_x - 20, ultra_y, 0, 4, 4);
    end
  end
end
