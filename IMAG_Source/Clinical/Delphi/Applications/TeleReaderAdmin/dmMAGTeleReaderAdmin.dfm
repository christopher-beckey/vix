object DataModule1: TDataModule1
  OldCreateOrder = False
  Left = 499
  Top = 246
  Height = 150
  Width = 215
  object Broker: TRPCBroker
    ClearParameters = True
    ClearResults = True
    Connected = False
    ListenerPort = 9300
    RpcVersion = '0'
    Server = 'localhost'
    KernelLogIn = True
    LogIn.Mode = lmAVCodes
    LogIn.PromptDivision = False
    OldConnectionOnly = False
    Left = 24
    Top = 24
  end
end
