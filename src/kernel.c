#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble."
#endif

#if !defined(__i386__)
#error "This needs to be compiled with a ix86-elf compiler."
#endif

uint32_t real_rand(uint32_t max);

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

enum vga_color {
  COLOR_BLACK = 0,
  COLOR_BLUE = 1,
  COLOR_GREEN = 2,
  COLOR_CYAN = 3,
  COLOR_RED = 4,
  COLOR_MAGENTA = 5,
  COLOR_BROWN = 6,
  COLOR_LIGHT_GREY = 7,
  COLOR_DARK_GREY = 8,
  COLOR_LIGHT_BLUE = 9,
  COLOR_LIGHT_GREEN = 10,
  COLOR_LIGHT_CYAN = 11,
  COLOR_LIGHT_RED = 12,
  COLOR_LIGHT_MAGENTA = 13,
  COLOR_LIGHT_BROWN = 14,
  COLOR_WHITE = 15
};

struct terminal {
  size_t row;
  size_t column;
  uint8_t color;
  uint16_t* buffer;
};

uint8_t make_color(enum vga_color foreground_color, enum vga_color background_color) {
  return foreground_color | background_color << 4;
}

uint16_t make_vga_entry(char c, uint8_t color) {
  uint16_t c16 = c;

  uint16_t color16 = color;

  return c16 | color16 << 8;
}

size_t string_length(const char* string) {
  size_t length = 0;

  while (string[length] != 0) {
    length++;
  }

  return length;
}

void terminal_initialize(struct terminal* t) {
  t->row = 0;

  t->column = 0;

  t->color = make_color(COLOR_LIGHT_GREY, COLOR_BLACK);

  t->buffer = (uint16_t*)0xB8000;

  for (size_t y = 0; y < VGA_HEIGHT; y++) {
    for (size_t x = 0; x < VGA_WIDTH; x++) {
      const size_t index = y * VGA_WIDTH + x;

      t->buffer[index] = make_vga_entry(' ', t->color);
    }
  }
}

void terminal_set_color(struct terminal* t, uint8_t color) {
  t->color = color;
}

void terminal_put_entry_at(struct terminal* t, char c, uint8_t color, size_t x, size_t y) {
  const size_t index = y * VGA_WIDTH + x;

  t->buffer[index] = make_vga_entry(c, color);
}

void terminal_put_char(struct terminal* t, char c) {
  terminal_put_entry_at(t, c, t->color, t->column, t-> row);

  if (++t->column == VGA_WIDTH) {
    t->column = 0;

    if (++t->row == VGA_HEIGHT) {
      t->row = 0;
    }
  }
}

void terminal_write_string(struct terminal* t, const char* string) {
  size_t length = string_length(string);

  for (size_t i = 0; i < length; i++) {
    terminal_put_char(t, string[i]);
  }
}

void terminal_scroll(struct terminal* t, size_t numberOfLines) {
  if (numberOfLines > VGA_HEIGHT) {
    numberOfLines = VGA_HEIGHT;
  }

  if (numberOfLines > 0) {
    for (size_t y = VGA_HEIGHT - (VGA_HEIGHT - numberOfLines); y < VGA_HEIGHT; y += 1) {
      for (size_t x = 0; x < VGA_WIDTH; x += 1) {
        const size_t originalIndex = y * VGA_WIDTH + x;

        const size_t newIndex = (y - numberOfLines) * VGA_WIDTH + x;

        t->buffer[newIndex] = t->buffer[originalIndex];
      }
    }

    for (size_t y = VGA_HEIGHT - numberOfLines; y < VGA_HEIGHT; y += 1) {
      for (size_t x = 0; x < VGA_WIDTH; x += 1) {
        t->color = make_color(COLOR_LIGHT_GREY, COLOR_BLACK);

        const size_t index = y * VGA_WIDTH + x;

        t->buffer[index] = make_vga_entry(' ', t->color);
      }
    }
  }
}

void kernel_main() {
  struct terminal t;

  terminal_initialize(&t);

  /* while(true) { */

  /* } */



  for (uint32_t i = 0; i < VGA_HEIGHT * VGA_WIDTH; i++) {
    enum vga_color fg = real_rand(16);

    enum vga_color bg = real_rand(16);

    /* while (fg != bg) { */
    /*   bg = real_rand(16); */
    /* } */

    terminal_set_color(&t, make_color(fg, bg));

    if (i % 2 == 0) {
      terminal_put_char(&t, 'L');
    } else {
      terminal_put_char(&t, 'O');
    }
  }

  //  terminal_scroll(&t, 3);
}
