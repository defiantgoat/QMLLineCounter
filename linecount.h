#ifndef LINECOUNT_H
#define LINECOUNT_H

#include <QObject>
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QVector>
#include <QJsonObject>

class LineCount : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(int lineCount NOTIFY lineCountChanged)

public:
    explicit LineCount(QObject *parent = nullptr);

public slots:
    int parseDir(QString path);

signals:
    void lineCountComplete(int count);
    void fileRead(QJsonObject fileData);

private:
    int countLines(QString path);
    int lineCount;
};

#endif // LINECOUNT_H
