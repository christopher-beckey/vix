function DicomInputStreamReader() {
    this.inputBuffer;
    this.inputStreamReader;
    this.readDICOMBytes = readDICOMBytes;
    this.getInputBuffer = getInputBuffer;
    this.getReader = getReader;
}

function readDICOMBytes(fileContent) {
    this.inputStreamReader = new BinFileReader(fileContent);
    this.inputBuffer = new Array(this.inputStreamReader.getFileSize);
    this.inputBuffer = fileContent
}

function getInputBuffer() {
    return this.inputBuffer;
}

function getReader() {
    return this.inputStreamReader;
}
