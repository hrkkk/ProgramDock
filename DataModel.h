#ifndef DATAMODEL_H
#define DATAMODEL_H

#include <QAbstractListModel>

class DataModel : public QAbstractListModel
{
    Q_OBJECT
public:
    DataModel(const QString& flag);

    typedef struct ProgramInfo {
        QString name;
        QString iconUrl;
        QString execCmd;
        QString cmdPara;
    } ProgramInfo;

    enum Role {
        NameRole = Qt::UserRole + 1,
        IconRole,
        ExecRole,
        ParaRole
    };

    // QAbstractListModel overrides
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;


    Q_INVOKABLE void execProgram(int index,const QList<QString>& parameters);
    Q_INVOKABLE QStringList getItem(int index) const;
    Q_INVOKABLE void setItem(int index, QStringList content);
    Q_INVOKABLE void exchangeItem(int index1, int index2);
    Q_INVOKABLE void addItem(QStringList content);
    Q_INVOKABLE void deleteItem(int index);
    Q_INVOKABLE void readFromFile();
    Q_INVOKABLE void writeToFile();

private:
    QList<ProgramInfo> m_programList;
    QString m_recordFileUrl = "./programRecord.ini";;
};

#endif // DATAMODEL_H
