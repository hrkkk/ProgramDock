#include "DataModel.h"


#include <QSettings>
#include <Windows.h>

DataModel::DataModel(const QString& flag)
{
    QList<QStringList> programList;

    if (flag == "UserProgram") {
        readFromFile();
        // programList.append({"CLion", "Clion.png", "D:\\CLion\\bin\\clion64.exe", ""});
        // programList.append({"PyCharm", "PyCharm.png", "D:\\PyCharm\\bin\\pycharm64.exe", ""});
        // programList.append({"火绒", "Huorong.png", "E:\\火绒\\Huorong\\Sysdiag\\bin\\HipsMain.exe", ""});
        // programList.append({"Lightroom", "Lightroom.png", "E:\\Lightroom\\Adobe Lightroom Classic\\Lightroom.exe", ""});
        // programList.append({"Photoshop", "Photoshop.png", "E:\\Photoshop\\Adobe Photoshop 2023\\Photoshop.exe", ""});
        // programList.append({"Clash", "clash.png", "E:\\ClashForWindows\\Clash for Windows.exe", ""});
        // programList.append({"剪映", "JianYing.png", "E:\\JianyingPro\\JianyingPro.exe --src1", ""});
        // programList.append({"原神", "mihoyo.png", "P:\\mihoyo\\Genshin Impact\\launcher.exe", ""});
        // programList.append({"Steam", "Steam.png", "E:\\Qingfeng\\HeyboxAccelerator\\heyboxacc.exe", ""});
        // programList.append({"Word", "Word.png", "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE", ""});
        // programList.append({"Excel", "Excel.png", "C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE", ""});
        // programList.append({"PowerPoint", "PowerPoint.png", "C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE", ""});
        // programList.append({"VisualStudio", "VisualStudio.png", "D:\\VisualStudio\\Common7\\IDE\\devenv.exe", ""});
        // programList.append({"VSCode", "VSCode.png", "D:\\VSCode\\Code.exe", ""});
        // programList.append({"微信", "WeChat.png", "E:\\WeChat\\WeChat.exe", ""});
        // programList.append({"QQ", "QQ.png", "E:\\TencentQQ\\QQ.exe", ""});
        // programList.append({"QQ音乐", "QQMusic.png", "E:\\QQMusic\\QQMusic2005.19.51.08\\QQMusic.exe", ""});
        // programList.append({"Unity", "unity.png", "D:\\Unity\\UnityEditor\\2022.3.5f1c1\\Editor\\Unity.exe", ""});
        // // programList.append({"VMware", "VMware.png", "D:\\VMware\\VMware Workstation\\vmware.exe", ""});
        // programList.append({"WeGame", "wegame.png", "E:\\Program Files (x86)\\WeGame\\wegame.exe", ""});
        // programList.append({"WPS", "WPSOffice.png", "E:\\WPS Office\\ksolaunch.exe", ""});
        // programList.append({"ChatGPT", "ChatGPT.png", "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe", "https://chat.openai.com"});
        // programList.append({"Edge", "Edge.png", "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe", ""});
    } else if (flag == "SystemProgram") {
        programList.append({"设置", "setting.png", "ms-settings:", ""});
        programList.append({"桌面文件", "directory.png", "explorer.exe", "C:\\Users\\hrkkk\\Desktop"});
        programList.append({"控制面板", "ControlPanel.png", "shell:ControlPanelFolder", ""});
        programList.append({"文件资源管理器", "PC.png", "explorer.exe", ""});
        programList.append({"回收站", "Garbage.png", "shell:RecycleBinFolder", ""});

        for (int i = 0; i < programList.size(); i++) {
            ProgramInfo programInfo = {
                .name = programList.at(i).at(0),
                .iconUrl = programList.at(i).at(1),
                .execCmd = programList.at(i).at(2),
                .cmdPara = programList.at(i).at(3)
            };

            m_programList.append(programInfo);
        }
    }

    // if (flag == "UserProgram") {
    //     writeToFile("./programRecord.ini");
    // }
}

int DataModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_programList.size();
}

QVariant DataModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() < 0 || index.row() >= m_programList.size())
        return QVariant();

    if (role == NameRole) {
        return m_programList.at(index.row()).name;
    } else if (role == IconRole) {
        return m_programList.at(index.row()).iconUrl;
    } else if (role == ExecRole) {
        return m_programList.at(index.row()).execCmd;
    } else if (role == ParaRole) {
        return m_programList.at(index.row()).cmdPara;
    }

    return QVariant();
}

QHash<int, QByteArray> DataModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "NameRole";
    roles[IconRole] = "IconRole";
    roles[ExecRole] = "ExecRole";
    roles[ParaRole] = "ParaRole";

    return roles;
}

void DataModel::readFromFile()
{
    QSettings settings(m_recordFileUrl, QSettings::IniFormat);

    // 获取INI文件中节的数量
    int num = settings.childGroups().size();

    m_programList.clear();

    for (int i = 0; i < num; i++) {
        QString name = settings.value(QString("PROGRAM%1/NAME").arg(i)).toString();
        QString iconUrl = settings.value(QString("PROGRAM%1/ICON").arg(i)).toString();
        QString execCmd = settings.value(QString("PROGRAM%1/EXEC").arg(i)).toString();
        QString cmdPara = settings.value(QString("PROGRAM%1/PARA").arg(i)).toString();

        m_programList.append({name, iconUrl, execCmd, cmdPara});
    }
}

void DataModel::writeToFile()
{
    QSettings settings(m_recordFileUrl, QSettings::IniFormat);

    settings.clear();

    for (int i = 0; i < m_programList.size(); i++) {
        settings.setValue(QString("PROGRAM%1/NAME").arg(i), m_programList.at(i).name);
        settings.setValue(QString("PROGRAM%1/ICON").arg(i), m_programList.at(i).iconUrl);
        settings.setValue(QString("PROGRAM%1/EXEC").arg(i), m_programList.at(i).execCmd);
        settings.setValue(QString("PROGRAM%1/PARA").arg(i), m_programList.at(i).cmdPara);
    }
}

QStringList DataModel::getItem(int index) const
{
    if (index >= 0 && index < m_programList.size()) {
        QStringList strList;
        strList.append(m_programList.at(index).name);
        strList.append(m_programList.at(index).iconUrl);
        strList.append(m_programList.at(index).execCmd);
        strList.append(m_programList.at(index).cmdPara);

        return strList;
    } else {
        return QStringList({"", "", "", ""});
    }
}

void DataModel::setItem(int index, QStringList content)
{
    if (index >= 0 && index < m_programList.size()) {
        m_programList[index].name = content.at(0);
        m_programList[index].iconUrl = content.at(1);
        m_programList[index].execCmd = content.at(2);
        m_programList[index].cmdPara = content.at(3);

        // 通知视图更新
        QModelIndex modelIndex = createIndex(index, 0);
        emit dataChanged(modelIndex, modelIndex, QVector<int>());
    }
}

void DataModel::exchangeItem(int index1, int index2)
{
    if (index1 < 0 || index1 >= m_programList.size() || index2 < 0 || index2 >= m_programList.size()) {
        return;
    }

    // 交换两行数据
    ProgramInfo programInfo = m_programList[index1];
    m_programList[index1] = m_programList[index2];
    m_programList[index2] = programInfo;

    // 通知视图更新
    if (index1 <= index2) {
        QModelIndex modelIndex1 = createIndex(index1, 0);
        QModelIndex modelIndex2 = createIndex(index2, 0);
        emit dataChanged(modelIndex1, modelIndex2, QVector<int>());
    } else {
        QModelIndex modelIndex1 = createIndex(index2, 0);
        QModelIndex modelIndex2 = createIndex(index1, 0);
        emit dataChanged(modelIndex1, modelIndex2, QVector<int>());
    }
}

void DataModel::addItem(QStringList content)
{

}

void DataModel::deleteItem(int index)
{
    if (index < 0 || index >= m_programList.size()) {
        return;
    }

}

void DataModel::execProgram(int index, const QList<QString>& parameters)
{
    if (index >= 0 && index < m_programList.size()) {
        // 程序执行命令
        std::wstring myStdWString = m_programList[index].execCmd.toStdWString();
        LPCWSTR command = myStdWString.c_str();

        // 程序执行参数
        QString parameter;

        // 添加程序自带参数
        if (m_programList[index].cmdPara != "") {
            parameter += " " + m_programList[index].cmdPara;
        }

        // 添加附加参数
        for (int i = 0; i < parameters.size(); ++i) {
            parameter += " " + parameters.at(i);
        }

        std::wstring paraWString = parameter.toStdWString();
        LPCWSTR parameters = paraWString.c_str();

        ShellExecute(NULL, L"open", command, parameters, NULL, SW_SHOWNORMAL);
    }
}
