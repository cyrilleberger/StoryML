#ifndef EXECUTECOMMAND_H
#define EXECUTECOMMAND_H

#include <QObject>
#include <QStringList>

class QProcess;

class ExecuteCommand : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString program READ program WRITE setProgram NOTIFY programChanged)
  Q_PROPERTY(QString standardOutput READ standardOutput NOTIFY standardOutputChanged)
  Q_PROPERTY(QString standardError READ standardError NOTIFY standardErrorChanged)
  Q_PROPERTY(QString output READ output NOTIFY outputChanged)
  Q_PROPERTY(QStringList arguments READ arguments WRITE setArguments NOTIFY argumentsChanged)
public:
  ExecuteCommand();
public:
  Q_INVOKABLE void start();
  Q_INVOKABLE void kill();
  Q_INVOKABLE void write(const QString& _text);
public:
  QString program() const { return m_program; }
  void setProgram(const QString& _program) { m_program = _program; emit(programChanged()); }
  QString standardOutput() const { return m_standardOutput; }
  QString standardError() const { return m_standardError; }
  QString output() const { return m_output; }
  QStringList arguments() const { return m_arguments; }
  void setArguments(const QStringList& _arguments) { m_arguments = _arguments; emit(argumentsChanged()); }
signals:
  void programChanged();
  void standardOutputChanged();
  void standardErrorChanged();
  void outputChanged();
  void argumentsChanged();
private slots:
  void readStandardError();
  void readStandardOutput();
private:
  QProcess* m_process;
  QString m_program, m_standardOutput, m_standardError, m_output;
  QStringList m_arguments;
};

#endif // EXECUTECOMMAND_H
