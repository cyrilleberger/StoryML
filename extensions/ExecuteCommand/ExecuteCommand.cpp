#include "ExecuteCommand.h"

#include <QDebug>
#include <QProcess>

ExecuteCommand::ExecuteCommand() : m_process(0)
{
}

void ExecuteCommand::start()
{
  if(m_process and m_process->state() != QProcess::NotRunning)
  {
    qWarning() << "Process has already been started";
    return;
  }
  if(m_process)
  {
    delete m_process;
    m_process = 0;
  }
  m_process = new QProcess;
  connect(m_process, SIGNAL(readyReadStandardError()), this, SLOT(readStandardError()));
  connect(m_process, SIGNAL(readyReadStandardOutput()), this, SLOT(readStandardOutput()));
  m_process->start(m_program, m_arguments);
}

void ExecuteCommand::kill()
{
  if(m_process == 0 or m_process->state() == QProcess::NotRunning)
  {
    qWarning() << "Process is not running";
    return;
  }
  m_process->kill();
}

void ExecuteCommand::readStandardError()
{
  QString str = m_process->readAllStandardError();
  m_standardError  += str;
  m_output         += str;
  emit(standardErrorChanged());
  emit(outputChanged());
}

void ExecuteCommand::readStandardOutput()
{
  QString str = m_process->readAllStandardOutput();
  m_standardOutput += str;
  m_output         += str;
  emit(standardOutputChanged());
  emit(outputChanged());
}

void ExecuteCommand::write(const QString &_text)
{
  if(m_process == 0 or m_process->state() == QProcess::NotRunning)
  {
    qWarning() << "Process not yet started";
    return;
  }
  m_process->write(_text.toUtf8());
}


