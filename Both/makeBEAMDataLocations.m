function makeBEAMDataLocations()
    folders = ["Preprocessed", "Coefficients", "Processed", "Metrics", "Final"];

    for folder = 1:numel(folders)
        folderName = append("Data/", folders(folder));
        if ~isfolder(folderName)
            mkdir(folderName)
        end
    end
end