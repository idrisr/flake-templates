module Params where

import Options.Applicative

data Params = Params
    { input :: FilePath
    , url :: String
    , output :: OutputFile
    }
    deriving (Show)

data OutputFile = OutputFile FilePath | AppendInput
    deriving (Show)

cmdLineParser :: IO Params
cmdLineParser = execParser opts
  where
    opts = info (parseParams <**> helper) (fullDesc <> progDesc "do something cool with this app template")

parseParams :: Parser Params
parseParams =
    Params
        <$> strArgument
            ( metavar "<INPUT>"
                <> help "pdf file for processing"
            )
        <*> strOption
            ( metavar "<URL>"
                <> short 'u'
                <> long "url"
                <> help "url for new cover"
            )
        <*> (fileOutput <|> defaultOutput)

fileOutput :: Parser OutputFile
fileOutput =
    OutputFile
        <$> strOption
            ( metavar "<OUTPUT>"
                <> short 'o'
                <> long "output"
                <> help "output file for new pdf"
            )

defaultOutput :: Parser OutputFile
defaultOutput =
    flag'
        AppendInput
        ( long "append"
            <> short 'a'
            <> help "use input file name as basis for output file name"
        )
