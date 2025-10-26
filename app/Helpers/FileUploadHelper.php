<?php

declare(strict_types=1);

namespace App\Helpers;

use Psr\Http\Message\UploadedFileInterface;

/**
 * Helper class for handling file uploads with validation and processing.
 */
class FileUploadHelper
{
    /**
     * Process and save an uploaded file.
     *
     * @param UploadedFileInterface $uploadedFile The uploaded file
     * @param string $directory Subdirectory within uploads (e.g., 'profiles', 'documents')
     * @param array $options Optional configuration (allowedTypes, maxSize)
     * @return array Result with 'success' boolean, 'path' or 'error' message
     */
    public static function processUpload(UploadedFileInterface $uploadedFile, string $directory = '', array $options = []): array
    {
        // Validate file
        $validation = self::validate($uploadedFile, $options);
        if (!$validation['valid']) {
            return ['success' => false, 'error' => $validation['error']];
        }

        // Generate unique filename
        $filename = self::generateUniqueFilename($uploadedFile);

        // Build full directory path
        $uploadPath = APP_BASE_DIR_PATH . '/public/uploads';
        if (!empty($directory)) {
            $uploadPath .= '/' . $directory;
        }

        // Create directory if it doesn't exist
        if (!is_dir($uploadPath)) {
            mkdir($uploadPath, 0755, true);
        }

        // Full path for the file
        $filepath = $uploadPath . '/' . $filename;

        try {
            // Move uploaded file to destination
            $uploadedFile->moveTo($filepath);

            // Return relative path for database storage
            $relativePath = '/uploads';
            if (!empty($directory)) {
                $relativePath .= '/' . $directory;
            }
            $relativePath .= '/' . $filename;

            return [
                'success' => true,
                'path' => $relativePath,
                'filename' => $filename
            ];
        } catch (\Exception $e) {
            return [
                'success' => false,
                'error' => 'Failed to save file: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Validate uploaded file.
     *
     * @param UploadedFileInterface $uploadedFile The file to validate
     * @param array $options Optional configuration (allowedTypes, maxSize)
     * @return array Validation result with 'valid' boolean and 'error' message if invalid
     */
    public static function validate(UploadedFileInterface $uploadedFile, array $options = []): array
    {
        // Check for upload errors
        if ($uploadedFile->getError() !== UPLOAD_ERR_OK) {
            return [
                'valid' => false,
                'error' => self::getUploadErrorMessage($uploadedFile->getError())
            ];
        }

        // Check file size (default 5MB max)
        $maxSize = $options['maxSize'] ?? (5 * 1024 * 1024); // 5MB in bytes
        if ($uploadedFile->getSize() > $maxSize) {
            $maxSizeMB = round($maxSize / (1024 * 1024), 2);
            return [
                'valid' => false,
                'error' => "File size exceeds maximum allowed size of {$maxSizeMB}MB."
            ];
        }

        // Check file type (default: common image and document types)
        $allowedMimeTypes = $options['allowedTypes'] ?? [
            'image/jpeg',
            'image/png',
            'image/gif',
            'application/pdf',
            'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        ];

        $clientMediaType = $uploadedFile->getClientMediaType();
        if (!in_array($clientMediaType, $allowedMimeTypes)) {
            return [
                'valid' => false,
                'error' => 'Invalid file type. Please upload a supported file format.'
            ];
        }

        return ['valid' => true];
    }

    /**
     * Generate unique filename to prevent overwrites.
     *
     * @param UploadedFileInterface $uploadedFile The uploaded file
     * @return string Unique filename
     */
    public static function generateUniqueFilename(UploadedFileInterface $uploadedFile): string
    {
        $originalName = $uploadedFile->getClientFilename();
        $extension = pathinfo($originalName, PATHINFO_EXTENSION);

        // Create unique name: timestamp_randomstring.extension
        $uniqueName = time() . '_' . bin2hex(random_bytes(8));

        if (!empty($extension)) {
            $uniqueName .= '.' . strtolower($extension);
        }

        return $uniqueName;
    }

    /**
     * Get human-readable upload error messages.
     *
     * @param int $errorCode PHP upload error code
     * @return string Error message
     */
    public static function getUploadErrorMessage(int $errorCode): string
    {
        switch ($errorCode) {
            case UPLOAD_ERR_INI_SIZE:
                return 'File exceeds maximum size allowed by server.';
            case UPLOAD_ERR_FORM_SIZE:
                return 'File exceeds maximum size specified in form.';
            case UPLOAD_ERR_PARTIAL:
                return 'File was only partially uploaded.';
            case UPLOAD_ERR_NO_FILE:
                return 'No file was uploaded.';
            case UPLOAD_ERR_NO_TMP_DIR:
                return 'Missing temporary upload directory.';
            case UPLOAD_ERR_CANT_WRITE:
                return 'Failed to write file to disk.';
            case UPLOAD_ERR_EXTENSION:
                return 'File upload stopped by PHP extension.';
            default:
                return 'Unknown upload error.';
        }
    }

    /**
     * Process multiple uploaded files.
     *
     * @param array $uploadedFiles Array of UploadedFileInterface objects
     * @param string $directory Subdirectory within uploads
     * @param array $options Optional configuration
     * @return array Array with 'successful' and 'failed' arrays
     */
    public static function processMultipleUploads(array $uploadedFiles, string $directory = '', array $options = []): array
    {
        $successful = [];
        $failed = [];

        foreach ($uploadedFiles as $file) {
            if ($file->getError() === UPLOAD_ERR_OK) {
                $result = self::processUpload($file, $directory, $options);

                if ($result['success']) {
                    $successful[] = $result;
                } else {
                    $failed[] = $result['error'];
                }
            }
        }

        return [
            'successful' => $successful,
            'failed' => $failed
        ];
    }
}
