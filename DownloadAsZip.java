package sample;

import com.sas.hls.macro.results.Result;
import com.sas.hls.macro.results.SasActionStatusResult;
import com.sas.hls.macro.service.BatchRepositoryService;
import com.sas.hls.macro.service.SessionService;


//  Downloads a SAS Drug Development repository object as a zip file. 

public class DownloadAsZip {
	
	
	public static void main(String[] args) {
		Result rs = new Result();
		SasActionStatusResult sasr = new SasActionStatusResult();
		
		String sddhost = "";
		String user= "";
		String password = "";
		String sdd_path = "";
		String local_path = "";
		
		
		 for (int i = 0; i < args.length; i++) {
			 
			 if (args[i].equalsIgnoreCase("-help")) {
				 System.out.println(" Description:  ");
 				 System.out.println("              Download a SAS Drug Development repository object as a zip file. "  ) ;	
				 System.out.println(" Usage:  ");
				 System.out.println("        java sample.DownloadAsZip [-s <server URL>] [-u <username>] [-p <password>] [-r <SDD repository folder>] [-r <Local path and file (.zip)>] ");

				 System.exit(1);
			 }
			 
			 
			 if (args[i].equalsIgnoreCase("-s")) {
				 i++;
				 sddhost = args[i];
				// System.out.println(sddhost);
			 }
			 
			 if (args[i].equalsIgnoreCase("-u")) {
				 i++;
				 user = args[i];
			 }
			 
			 if (args[i].equalsIgnoreCase("-p")) {
				 i++;
				 password = args[i];
			 }
			 
			 if (args[i].equalsIgnoreCase("-r")) {
				 i++;
				 sdd_path = args[i];
			 }
			 
			 if (args[i].equalsIgnoreCase("-l")) {
				 i++;
				 local_path = args[i];
			 }
			 
			 	 
		 }
		

		
		SessionService.login(sddhost, user, password, "", "", "", "", rs);
		   System.out.print("Login ...  ");
		// System.out.println(rs.getReturnCode());
	       System.out.println(rs.getReturnMessage());
			
		BatchRepositoryService.downloadAsZip(sdd_path, local_path, "1", sasr);
	    System.out.print("Zip and download ...  ");
		System.out.println(sasr.getReturnMessage());
		
		SessionService.logout(rs);

		//System.out.println(rs.getReturnCode());
		//System.out.println(rs.getReturnMessage());
	}

}
