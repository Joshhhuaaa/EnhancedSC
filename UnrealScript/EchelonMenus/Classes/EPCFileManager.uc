//=============================================================================
//  EPCFileManager.uc : Simple File manager
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/17 * Created by Alexandre Dionne
//=============================================================================
class EPCFileManager extends Object
			native
            noexport;

struct SFileDetails
{
    var String  Filename;
    var String  FileTime;   //Create time
    var String  FileDate;   //Create Date
	var String  FileCompletTime;
};

var Array<SFileDetails> m_pDetailedFileList;    //Result of a DetailedFindFiles sucessfull call
var Array<String> m_pFileList;                  //Result of a FindFiles sucessfull call

//Filename can include extension and can include a path
native(4006) final function INT FindFiles(string Filename, OPTIONAL BOOL bFiles, OPTIONAL BOOL bDirectories); //This will fill m_pFileList and return the amount of files found
native(4019) final function INT DetailedFindFiles(string Filename, OPTIONAL BOOL bFiles, OPTIONAL BOOL bDirectories);

//Filename must include extension and can include a path
native(4007) final function BOOL DeleteFile(string Filename);

//To delete a dir
native(4009) final function BOOL DeleteDirectory(string Filename, OPTIONAL BOOL Tree);

// Validate CD
native(4021) final function BOOL ValidateCD();
