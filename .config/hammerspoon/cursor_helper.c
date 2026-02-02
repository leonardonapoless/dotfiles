#include <ApplicationServices/ApplicationServices.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

typedef int CGSConnectionID;
extern CGSConnectionID _CGSDefaultConnection(void);
extern CGError CGSSetConnectionProperty(CGSConnectionID cid,
                                        CGSConnectionID targetCID,
                                        CFStringRef key, CFTypeRef value);

void set_cursor_visible(bool visible) {
  CGSConnectionID cid = _CGSDefaultConnection();
  CFStringRef propertyString = CFSTR("SetsCursorInBackground");

  if (visible) {
    CGDisplayShowCursor(kCGDirectMainDisplay);
    CGSSetConnectionProperty(cid, cid, propertyString, kCFBooleanFalse);
  } else {
    CGSSetConnectionProperty(cid, cid, propertyString, kCFBooleanTrue);
    CGDisplayHideCursor(kCGDirectMainDisplay);
  }
}

int main(int argc, char **argv) {
  char buffer[100];
  setbuf(stdout, NULL);

  set_cursor_visible(true);

  while (fgets(buffer, sizeof(buffer), stdin)) {
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n') {
      buffer[len - 1] = '\0';
    }

    if (strcmp(buffer, "hide") == 0) {
      set_cursor_visible(false);
      printf("ok: hidden\n");
    } else if (strcmp(buffer, "show") == 0) {
      set_cursor_visible(true);
      printf("ok: shown\n");
    } else if (strcmp(buffer, "quit") == 0) {
      break;
    } else {
      printf("error: unknown command\n");
    }
  }

  set_cursor_visible(true);
  return 0;
}
