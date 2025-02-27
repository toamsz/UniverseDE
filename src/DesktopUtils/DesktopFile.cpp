#include <DesktopsUtils/DesktopFile.hpp>

#include <core.hpp>

int DesktopFile::run() {
    if (desktopEntry.noDisplay || desktopEntry.hidden) {
        qWarning() << "Application is marked as hidden or noDisplay, not launching.";
        return -1;
    }

    QString execCmd = desktopEntry.exec.trimmed();
    if (execCmd.isEmpty()) {
        qWarning() << "Exec command is empty!";
        return -1;
    }

    execCmd.replace("%f", "").replace("%F", "");
    execCmd.replace("%u", "").replace("%U", "");
    execCmd.replace("%i", desktopEntry.icon.value("en", ""));
    execCmd.replace("%c", desktopEntry.name.value("en", ""));
    execCmd.replace("%k", path);

    QStringList args = execCmd.split(' ', Qt::SkipEmptyParts);
    if (args.isEmpty()) {
        qWarning() << "Invalid Exec format!";
        return -1;
    }

    QString program = args.takeFirst();

    QProcess* process = new QProcess();
    if (desktopEntry.terminal) {
        QString terminal = qEnvironmentVariable("TERMINAL", "x-terminal-emulator");
        process->start(terminal, QStringList() << "-e" << program << args);
    } else {
        process->start(program, args);
    }

    if (!process->waitForStarted())
        delete process;
    else
        process->setParent(nullptr);

    return 0;
}