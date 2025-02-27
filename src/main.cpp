#include <core.hpp>

#include <X11/X-Utils.hpp>

int main(int argc, char* argv[]) {
    QApplication Universe(argc, argv);

    QWidget w;
    w.setWindowTitle("Universe");

    w.setWindowFlags(Qt::FramelessWindowHint | Qt::WindowStaysOnBottomHint);
    w.setAttribute(Qt::WA_X11NetWmWindowTypeDesktop);
    w.resize(1920, 1080);

    QPushButton button("Open terminal", &w);
    button.setGeometry(100, 100, 200, 50);

    QObject::connect(&button, &QPushButton::clicked, []() { QProcess::startDetached("tilix", QStringList(), QDir::homePath()); });

    setDesktopWindowType(&w);
    w.show();

    return Universe.exec();
}