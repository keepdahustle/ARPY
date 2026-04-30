import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../utils/app_colors.dart';
import '../utils/storage_service.dart';
import '../widgets/modern_dialog.dart';
import '../models/project_model.dart';

class ProjectDetailScreen extends StatefulWidget {
  final MiniProject project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  String? _selectedFilePath;
  String? _selectedFileName;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        // Use FileType.custom when providing allowedExtensions (required by file_picker)
        type: FileType.custom,
        allowedExtensions: ['zip', 'rar', 'pdf', 'docx', 'doc', 'pptx', 'py', 'java', 'cpp', 'js', 'ts'],
      );

      if (result != null) {
        // Some providers (eg. cloud storage) may return null path but provide bytes.
        final file = result.files.single;
        String? pickedPath = file.path;

        if (pickedPath == null && file.bytes != null) {
          // Write bytes to a temporary file so we have a local path to store/use later.
          try {
            final tempDir = Directory.systemTemp;
            final tempFile = File('${tempDir.path}/${file.name}');
            await tempFile.writeAsBytes(file.bytes!);
            pickedPath = tempFile.path;
          } catch (e) {
            if (mounted) ModernDialog.showSnack(context, 'Gagal menyimpan file sementara: $e', isError: true);
          }
        }

        setState(() {
          _selectedFilePath = pickedPath;
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ModernDialog.showSnack(context, 'Error memilih file: $e', isError: true);
      }
    }
  }

  void _showConfirmationDialog() {
    if (_selectedFileName == null || _selectedFilePath == null) {
      ModernDialog.showSnack(context, 'Pilih file terlebih dahulu sebelum submit (file harus tersedia secara lokal).', isError: true);
      return;
    }

    ModernDialog.showConfirm(
      context,
      title: 'Konfirmasi Submission',
      message: 'Anda yakin ingin submit project ini?\n\nProject: ${_project.title}\nFile: $_selectedFileName\n\nSubmission tidak dapat diubah setelah ini.',
      confirmLabel: 'Submit',
      cancelLabel: 'Batal',
      onConfirm: () {
        _submitProject();
      },
    );
  }

  Future<void> _submitProject() async {
    setState(() => _isLoading = true);

    try {
      // Save to storage
      await StorageService.saveProjectProgress(
        projectId: _project.id,
        projectName: _project.title,
        status: 'submitted',
        uploadedFilePath: _selectedFilePath!,
        lastUpdated: DateTime.now(),
        estimatedDays: _project.estimatedDays,
      );

      if (mounted) {
        ModernDialog.showSnack(context, 'Project berhasil di-submit! ✓');

        // Go back after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ModernDialog.showSnack(context, 'Error: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  late MiniProject _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _project.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondaryLightBlue,
                      AppColors.secondaryLightBlue.withAlpha((0.7 * 255).round()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _project.icon,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _project.title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.3 * 255).round()),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _project.difficulty,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.3 * 255).round()),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_project.estimatedDays} hari',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Brief
              Text(
                'Deskripsi Project',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarkBlue,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _project.briefContent,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 24),

              // File Upload Section
              Text(
                'Upload Project',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarkBlue,
                ),
              ),

              const SizedBox(height: 12),

              // File Picker Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha((0.05 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withAlpha((0.2 * 255).round()),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    if (_selectedFileName == null) ...[
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: AppColors.secondaryLightBlue,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pilih file untuk di-upload',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Format: ZIP, RAR, PDF, atau kode sumber',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.check_circle,
                        size: 40,
                        color: AppColors.primaryTeal,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedFileName!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'File siap untuk di-submit',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.folder_open),
                        label: Text(
                          _selectedFileName == null
                              ? 'Pilih File'
                              : 'Ganti File',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryLightBlue,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.secondaryLightBlue,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Notes
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withAlpha((0.3 * 255).round()),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pastikan semua file sudah lengkap sebelum submit. Anda tidak dapat mengubah submission setelah tombol submit ditekan.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _showConfirmationDialog,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _isLoading ? 'Sedang Submit...' : 'Submit Project',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedFileName != null
                        ? AppColors.secondaryLightBlue
                        : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
