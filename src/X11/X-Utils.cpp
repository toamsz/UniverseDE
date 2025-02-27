#include <core.hpp>

void setDesktopWindowType(QWidget* widget) {
    Display* display = QX11Info::display();
    Window win = widget->winId();

    Atom wm_type = XInternAtom(display, "_NET_WM_WINDOW_TYPE", false);
    Atom desktop = XInternAtom(display, "_NET_WM_WINDOW_TYPE_DESKTOP", false);
    XChangeProperty(display, win, wm_type, XA_ATOM, 32, PropModeReplace, (unsigned char*)&desktop, 1);
}