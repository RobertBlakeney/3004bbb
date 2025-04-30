from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import RemoteController
from mininet.link import TCLink
from mininet.log import setLogLevel, info
from mininet.node import OVSSwitch
from time import sleep
import os

topos = {'lineartopo' : (lambda : LinearTopo())}

class LinearTopo(Topo):
    def __init__(self):
	Topo.__init__(self)

	#Add switches
	s1 = self.addSwitch('s1', protocols='OpenFlow13')
	s2 = self.addSwitch('s2', protocols='OpenFlow13')
	s3 = self.addSwitch('s3', protocols='OpenFlow13')

	#Add hosts
	h1 = self.addHost('h1')
	h2 = self.addHost('h2')

	#Links
	self.addLink(h1, s1, cls=TCLink, bw=100)
	self.addLink(s1, s2, cls=TCLink, bw=100)
	self.addLink(s2, s3, cls=TCLink, bw=10)
	self.addLink(s3, h2, cls=TCLink, bw=100)

def StartNetwork():
    os.system('sudo mn -c')

    topo = LinearTopo()
    net = Mininet(topo=topo, link=TCLink, controller=RemoteController('odl', ip='192.168.10.221', port=6633), switch=OVSSwitch, autoSetMacs=True)

    print ("Starting Network")
    net.start()
    sleep(10)

    print ("Pinging devices")
    net.pingAll()

    print ("Start Apache")
    h1 = net.get('h1')
    h1.cmd('service apache2 start &')


    print ("Start firefox")
    h2 = net.get('h2')
    h2.cmd('firefox http://h1/dashjs/index.html &')

    net.interact()
    net.stop()

if __name__ == '__main__':
    setLogLevel('info')
    StartNetwork()