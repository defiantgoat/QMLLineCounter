#include "linecount.h"
#include <QtDebug>

LineCount::LineCount(QObject *parent) : QObject(parent)
{

}

int LineCount::countLines(QString path){
    QFile f(path);
    int cnt = 0;

    if(f.open(QIODevice::ReadOnly | QIODevice::Text)){
        QTextStream read(&f);
        QString line;
        bool comment = false;
        while(!read.atEnd()){
            line = read.readLine();
            line = line.simplified();
            line.replace(" ","");
            if(line.size() >0){
                if(line.leftRef(2) != "//"){
                    if(line.contains("/*"))
                        comment = true;
                    if(line.contains("*/"))
                        comment = false;
                    if(!comment)
                        cnt++;
                }
            }
        }
    }
    f.close();

    QJsonObject fileJson {
        {"fileName", path},
        {"lineCount", cnt}
    };

    fileRead(fileJson);
    return cnt;
}

int LineCount::parseDir(QString path){
    //qDebug() << "Called the C++ slot" << path;
    QString newPath = path;
    int cnt = 0;
    QDir dir(newPath);
    QStringList dirs = dir.entryList(QDir::AllDirs |QDir::NoDotAndDotDot);
    QStringList file = dir.entryList(QDir::Files);
    for(QString dir : dirs){
            cnt += parseDir(path + "/" + dir);
            qDebug() << "Dir in Dirs" << dir;
    }

    for(QString s : file){
        //qDebug() << "File: " << s;
        if (s.splitRef('.').last() == "js" || s.splitRef('.').last() == "qml"){
            qDebug() << "File: " << s;
            cnt += countLines(path + "/" + s);
        }
    }
    qDebug() << "Count: " << cnt;
    lineCountComplete(cnt);
    return cnt;
}
