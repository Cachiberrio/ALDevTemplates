codeunit 85008 LibraryDOCTableName
{

    trigger OnRun()
    begin
    end;

    var
        LibraryUtility: Codeunit "Library - Utility";
        LibraryERM: Codeunit "Library - ERM";

    procedure CreateDOCTableNameHeader(var DOCTableNameHeader: Record DOCTableNameHeader)
    begin
        DOCTableNameHeader.Init;
        CreateDOCTableNameSetup;
        DOCTableNameHeader."No." := '';
        DOCTableNameHeader.Insert(true);
        DOCTableNameHeader.Description := LibraryUtility.GenerateRandomText(MaxStrLen(DOCTableNameHeader.Description));
        DOCTableNameHeader."Created By User Id." := UserId;
        DOCTableNameHeader."Posting Date" := WorkDate;
        DOCTableNameHeader.Modify(true);
    end;

    procedure CreateDOCTableNameLine(var DOCTableNameLine: Record DOCTableNameLine; DOCTableNameHeaderNo: Code[20])
    begin
        DOCTableNameLine.Init;
        DOCTableNameLine."Document No." := DOCTableNameHeaderNo;
        DOCTableNameLine."Line No." := FindNextLineNo(DOCTableNameHeaderNo);
        DOCTableNameLine.Insert;
        DOCTableNameLine.Description := LibraryUtility.GenerateRandomText(MaxStrLen(DOCTableNameLine.Description));
        DOCTableNameLine.Date := WorkDate;
        DOCTableNameLine.Modify;
    end;

    procedure PostDOCTableName(var DOCTableNameHeader: Record DOCTableNameHeader)
    var
        PostDocumentName: Codeunit PostDOCTableName;
    begin
        PostDocumentName.Run(DOCTableNameHeader);
    end;

    procedure CreateDOCTableNameSetup()
    var
        DOCTableNameSetup: Record DOCTableNameSetup;
    begin
        if not DOCTableNameSetup.Get then begin
            DOCTableNameSetup.Init;
            DOCTableNameSetup.Insert(true);
        end;
        if DOCTableNameSetup."DOCTableCaptionENU No. Series" = '' then begin
            DOCTableNameSetup."DOCTableCaptionENU No. Series" := LibraryERM.CreateNoSeriesCode;
            DOCTableNameSetup.Modify;
        end;
    end;

    local procedure FindNextLineNo(DOCTableNameHeaderNo: Code[20]): Integer
    var
        DOCTableNameLine: Record DOCTableNameLine;
    begin
        DOCTableNameLine.Reset;
        DOCTableNameLine.SetRange("Document No.", DOCTableNameHeaderNo);
        if DOCTableNameLine.FindLast then
            exit(DOCTableNameLine."Line No." + 10000)
        else
            exit(10000);
    end;
}

