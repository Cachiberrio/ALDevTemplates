codeunit 85009 TestDOCTableName
{
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    var
        LibraryDOCTableName: Codeunit LibraryDOCTableName;

    [Test]
    procedure PostDOCTableName()
    var
        DocumentNameHeader: Record DOCTableNameHeader;
        DocumentNameLine: Record DOCTableNameLine;
        i: Integer;
        ArrayDocumentNameLine: array[5] of Record DOCTableNameLine;
    begin
        // Given
        LibraryDOCTableName.CreateDOCTableNameHeader(DocumentNameHeader);
        for i := 1 to ArrayLen(ArrayDocumentNameLine) do begin
            LibraryDOCTableName.CreateDOCTableNameLine(DocumentNameLine, DocumentNameHeader."No.");
            ArrayDocumentNameLine[i] := DocumentNameLine;
        end;

        // When
        LibraryDOCTableName.PostDOCTableName(DocumentNameHeader);

        // Then
        TestPostedDOCTableNameHeader(DocumentNameHeader, ArrayDocumentNameLine);
    end;

    local procedure TestPostedDOCTableNameHeader(DocumentNameHeader: Record DOCTableNameHeader; ArrayDocumentNameLine: array[5] of Record DOCTableNameLine)
    var
        PostedDocumentNameHeader: Record PostedDOCTableNameHeader;
    begin
        PostedDocumentNameHeader.Get(DocumentNameHeader."No.");
        PostedDocumentNameHeader.TestField(Description, DocumentNameHeader.Description);
        PostedDocumentNameHeader.TestField("Created By User Id.", DocumentNameHeader."Created By User Id.");
        PostedDocumentNameHeader.TestField("Posting Date", DocumentNameHeader."Posting Date");
        PostedDocumentNameHeader.TestField("No. Series", DocumentNameHeader."No. Series");
        TestPostedDOCTableNameLines(DocumentNameHeader, ArrayDocumentNameLine);
    end;

    local procedure TestPostedDOCTableNameLines(DocumentNameHeader: Record DOCTableNameHeader; ArrayDocumentNameLine: array[5] of Record DOCTableNameLine)
    var
        DocumentNameLine: Record DOCTableNameLine;
        PostedDocumentNameLine: Record PostedDOCTableNameLine;
        i: Integer;
    begin
        for i := 1 to ArrayLen(ArrayDocumentNameLine) do begin
            PostedDocumentNameLine.Get(ArrayDocumentNameLine[i]."Document No.", ArrayDocumentNameLine[i]."Line No.");
            PostedDocumentNameLine.TestField(Description, ArrayDocumentNameLine[i].Description);
            PostedDocumentNameLine.TestField(Date, ArrayDocumentNameLine[i].Date);
        end;
    end;
}

