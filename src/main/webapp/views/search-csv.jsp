<%@ page language="java" import="java.util.*,java.text.*,gov.nysenate.openleg.*,gov.nysenate.openleg.search.*,gov.nysenate.openleg.model.*,gov.nysenate.openleg.util.*"  contentType="text/plain" pageEncoding="utf-8" %><%!
	public String format(String str) {
		if(str == null)
			return ",";
		
		if(str.contains(",")) {
			str = "\"" + str.replaceAll("\"","\"\"") + "\"";
		}
		
		return "," + str;
	}
%><%

response.setContentType("text/csv");
response.setHeader("Content-disposition","attachment;filename=search-" + new Date().getTime() +".csv");

SenateResponse sr = (SenateResponse)request.getAttribute("results");
int resultCount = sr.getResults().size();

int total = (Integer)sr.getMetadataByKey("totalresults");


ArrayList<String> attribs = new ArrayList<String>(Arrays.asList("billno", "chair", "committee", "cosponsors", "location", "sameas", "session-type", "sponsor", "status", "summary", "when", "year"));

Iterator<Result> it = sr.getResults().iterator();
Result r = null;

ArrayList<String> columns = new ArrayList<String>();
columns.addAll(Arrays.asList("type", "id", "title"));

ArrayList<String> rows = new ArrayList<String>();

while (it.hasNext()) {
	
	try {		
		r = it.next();
		
		String tuple = "";
		tuple += r.getOtype() 
					+ format(r.getOid())
					+ format(r.getTitle());
		
		r.getFields().remove("type");
		
		for(int i = 3; i < columns.size(); i++) {
			String key = columns.get(i);
			
			tuple += format(r.getFields().get(key));
			r.getFields().remove(key);
		}
		
		for(String key:r.getFields().keySet()) {			
			columns.add(key);
			
			tuple += format(r.getFields().get(key));
		}
		rows.add(tuple);
	}
	catch (Exception e) {
		//error with this document
	}
}

String header = "";
for(String column:columns) {
	header += column + ",";
}
header = header.replaceAll(",$","");

out.print(header + "\n");

for(String row:rows) {
	out.println(row);
}

%>