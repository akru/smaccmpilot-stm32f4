import Ivory.Tower
import Ivory.Tower.Compile
import Ivory.OS.Posix.Tower
import Ivory.OS.Posix.Tower.IO
import PX4.Tests.SensorsMonitor.Demux

app :: Tower e ()
app = do
  input <- readFD "stdin" stdin
  (sinkCompass, _) <- channel
  (sinkGyro, _) <- channel
  (sinkBaro, _) <- channel
  (sinkGPS, _) <- channel
  demux input sinkCompass sinkGyro sinkBaro sinkGPS

main :: IO ()
main = towerCompile (const $ return $ posix ()) app
