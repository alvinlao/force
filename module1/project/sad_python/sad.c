#include <stdio.c>

#define BLOCK_SIZE 10
#define WINDOW_SIZE 200
#define SEARCH_STEP 10
#define BORDER_THICKNESS 2

int RED[] = {0, 0, 255};
int GREEN[] = {0, 255, 0};
int BLUE[] = {255, 0, 0};

struct tuple{
	int[] blockx;
	int[] blocky;
};

struct drawtuple{
	int wx;
	int wy;
};

struct pixel{
	int r;
	int g;
	int b;
	int x;
	int y;
};

int block_step(prev_frame, frame, x, y, prevx, prevy){
	int delta = 0;
	for(int i = 0; i < BLOCK_SIZE; i++){
		for(int j = 0; j < BLOCK_SIZE; j++){
			prev = prev_frame[prevx + i, prevy + j];
			new = frame[x + i, y + j];
		
			delta += sad_pixel(prev, new);
		}
	}
	return delta;
}

int sad_pixel(a,b){
	int s = 0;
	for(int i = 0; i < 3; i++){
		s+= abs(a[i] - b[i]);
	}
	return s;
}

tuple step(prev_fram, frame, windowleftx, windowtopy, search_blockx, search_blocky){
	int searches;
	searches = (WINDOW_SIZE - BLOCK_SIZE)/SEARCH_STEP;
	
	tuple r;
	float s;
	float cur_s;
	int blockx, blocky;
	int blockx = 0;
	int blocky = 0;
	s = 100000;
	
	for(int i = 0; i < searches; i++){
		for(int j = 0; j < searches; j++){
			int x,y;
			x = windowleftx + (i * SEARCH_STEP);
			y = windowtopy + (j * SEARCH_STEP);
			cur_s = block_step(prev_frame, frame, x, y, search_blockx, search_blocky);
			
			if(cur_s < s){
				blockx = x;
				blocky = y;
				s = cur_s;
			}
		}
	}
	r = {blockx, blocky};
	return r;
}

void draw_box( int x, int y, int size, color){
	int leftx = x;
	int rightx = x + size;
	int topy = y;
	int bottomy = y + size;
	
	for(int i = leftx; i < rightx; i++){
		for(int j = topy; j < bottomy; j++){
			if( i < leftx + BORDER_THICKNESS || i > rightx - BORDER_THICKNESS || j < topy + BORDER_THICKNESS || j > bottomy - BORDER_THICKNESS){
				setPixelBuffer(j, i) = color;
			}
		}
	}
}

drawtuple center_window( int x, int y, int width, int height){
	wx = (x + BLOCK_SIZE/2) - (WINDOW_SIZE/2)
    wy = (y + BLOCK_SIZE/2) - (WINDOW_SIZE/2)

    if(wx < 0){
		wx = 0;
	}
	if(wy < 0){
		wy = 0;
	}

    wx = min(wx, width - WINDOW_SIZE)
    wy = min(wy, height - WINDOW_SIZE)
	
	if(wx > (width - WINDOW_SIZE)){
		wx = width - WINDOW_SIZE;
	}
	if(wy = height - WINDOW_SIZE){
		wy = height - WINDOW_SIZE;
	}
	
	drawtuple d = {wx, wy};
	return d;
}

void main (){
	getPixelBuffer;
	
	windowx = width/2 - WINDOW_SIZE/2;
	windowy = height/2 - WINDOW_SIZE/2;
	int x = windowx;
	int y = windowy;
	
	while(1){
		// get the frame
		// using step function get x and y values
		// set prev_frame to be current frame
		// draw the red box
		// draw the green box
		// "show image"
		// set windowx and windowy using center_window
	}
	
}