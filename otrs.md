#### query OTRS tickets from Centos7 using python script

```
yum install python-setuptools
yum install git
git clone https://github.com/ewsterrenburg/python-otrs.git
(more info on that github page^)
yum install epel-release
yum install python2-defusedxml
```

python script:
```
#!/usr/bin/env python                                   

from otrs.ticket.template import GenericTicketConnectorSOAP                                                     
from otrs.client import GenericInterfaceClient          
from otrs.ticket.objects import Ticket, Article, DynamicField, Attachment                                       
import xml.etree.cElementTree as ET                     

server_uri = r'https://otrs.example.com'            
webservice_name = 'GenericTicketConnectorSOAP'          
client = GenericInterfaceClient(server_uri, tc=GenericTicketConnectorSOAP(webservice_name))                     

# user session                                          
client.tc.SessionCreate(user_login='myuser1', password='mypassword')  

tickets = client.tc.TicketSearch(Queues='ActiveIT')     

root = ET.Element("external_stories", type="array")     

for x in range(len(tickets)):                           
   ticket = client.tc.TicketGet(tickets[x], get_articles=True, get_dynamic_fields=True, get_attachments=True)   
   article = ticket.articles()[0]                       

   row = ET.SubElement(root, "external_story")          

   field1 = ET.SubElement(row, "id").text = "OTRS-" + str(ticket.TicketID)                                      
   field2 = ET.SubElement(row, "name").text = ticket.Title                                                      
   field3 = ET.SubElement(row, "description").text = 'https://otrs.example.com/otrs/index.pl?Action=AgentTicketZoom;TicketID=' + str(tickets[x]) + " \n\n" + article.Body                                                   
   field4 = ET.SubElement(row, "requested_by").text = ticket.CustomerUserID                                     
   field5 = ET.SubElement(row, "created_at", type="datetime").text = ticket.Created                             

print '<?xml version="1.0" encoding="UTF-8"?>'          
tree = ET.ElementTree(root)                             
ET.dump(tree)                                           
```
