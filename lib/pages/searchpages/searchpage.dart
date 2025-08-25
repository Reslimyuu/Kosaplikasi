import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/kosmodel.dart';
import 'package:flutter_application_1/model/makananmodel.dart';
import 'package:flutter_application_1/widget/searchpagewidget/headersearch.dart';
import 'package:flutter_application_1/widget/itemkosdanmakanan/kositem.dart';
import 'package:flutter_application_1/widget/itemkosdanmakanan/makananitem.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchpage extends StatefulWidget {
  final VoidCallback onSearchTap;
  final String userName;
  const Searchpage({super.key, required this.onSearchTap, required this.userName});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  String activeselection = "Kos";
  List<Kos> dataList = [];
  List<Makanan> dataList1 = [];
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Data dummy untuk kos
  final List<Kos> kosList = [
    Kos(imageUrl: '', namaKos: 'Kos 1', rating: '4.8', harga: '1.200.000', durasiHarga: '/bulan', durasiHarga1: "", jarak: '1.2 km / dari kampus'),
    Kos(imageUrl: '', namaKos: 'Kos 2', rating: '4.5', harga: '1.000.000', durasiHarga: '/bulan', durasiHarga1: "hari", jarak: '1.5 km / dari kampus'),
    Kos(imageUrl: '', namaKos: 'Kos 3', rating: '4.9', harga: '1.500.000', durasiHarga: '/bulan', durasiHarga1: "", jarak: '0.8 km / dari kampus'),
    Kos(imageUrl: '', namaKos: 'Kos 4', rating: '4.9', harga: '1.500.000', durasiHarga: '/bulan', durasiHarga1: "", jarak: '0.8 km / dari kampus'),
  ];

  // Data dummy untuk makanan (pakai model Kos untuk sementara)
  final List<Makanan> makananList = [
    Makanan(imageUrl: '', namaMakanan: "Nasi Goreng Spesial", rating: "4.8", harga: "10.000", durasiHarga: "/Porsi", jarak: "1.2 Km / dari Kos"),
    Makanan(imageUrl: '', namaMakanan: "Ayam Geprek", rating: "4.5", harga: "15.000", durasiHarga: "/Porsi", jarak: "2.5 Km / dari Kos"),
    Makanan(imageUrl: '', namaMakanan: "Bakso Kalimantan", rating: "4.4", harga: "10.000", durasiHarga: "/Porsi", jarak: "2.4 Km / dari Kos"),
    Makanan(imageUrl: '', namaMakanan: "Sate Ayam", rating: "4.4", harga: "20.000", durasiHarga: "/Porsi", jarak: "2.8 Km / dari Kos"),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore) {
        _loadMoreData();
      }
    });
  }

  void _loadInitialData() {
    if (activeselection == "Kos") {
      dataList = List.from(kosList);
    } else {
      dataList1 = List.from(makananList);
    }
  }

  void _filterdata(String query) {
    if (activeselection == "Kos") {
      setState(() {
        dataList = kosList
            .where((item) => 
                item.namaKos.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        dataList1 = makananList
            .where((item) =>
                item.namaMakanan.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _loadMoreData() async {
    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));

    if (activeselection == "Kos") {
      List<Kos> newKos = List.generate(
        5,
        (index) => Kos(
          imageUrl: '',
          namaKos: 'Kos Baru ${dataList.length + index + 1}',
          rating: '4.${index % 10}',
          harga: '${1000000 + (dataList.length * 10000)}',
          durasiHarga: '/bulan',
          durasiHarga1: '',
          jarak: '${(index + 1) * 0.5} km / dari kampus',
        ),
      );
      setState(() {
        dataList.addAll(newKos);
      });
    } else {
      List<Makanan> newMakanan = List.generate(
        5,
        (index) => Makanan(
          imageUrl: '',
          namaMakanan: 'Menu Baru ${dataList1.length + index + 1}',
          rating: '4.${index % 10}',
          harga: '${15000 + (dataList1.length * 2000)}',
          durasiHarga: '/porsi',
          jarak: '${(index + 1) * 0.5} km / dari kos',
        ),
      );
      setState(() {
        dataList1.addAll(newMakanan);
      });
    }
    setState(() => isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xffF6f6f6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headersearch(userName: widget.userName),

              const SizedBox(height: 24),
              Text(
                "Mau Nyari Apa\nNih ?",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3582A9),
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterdata, 
                      onTap: widget.onSearchTap,
                      decoration: InputDecoration(
                        hintText: "Cari Disini",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey.withAlpha(40),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff3582A9),
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff3582A9),
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff3582A9),
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.search,
                        color: Color(0xff3582A9), size: 40),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSelectionContainer("Kos", Icons.home),
                  const SizedBox(width: 8),
                  _buildSelectionContainer("Makanan", Icons.fastfood),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: (activeselection == "Kos" ? dataList.length : dataList1.length) + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (activeselection == "Kos") {
                      if (index < dataList.length) {
                        return Kositem(kos: dataList[index]);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    } else {
                      if (index < dataList1.length) {
                        return Makananitem(makanan: dataList1[index]); // Pastikan widget MakananItem sudah ada
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    }
                  },
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionContainer(String label, IconData icon) {
    bool isSelected = activeselection == label;
    Color containerColor =
        isSelected ? const Color(0xff3582A9) : Colors.grey[300]!;
    Color iconAndTextColor =
        isSelected ? Colors.white : const Color(0xff3582A9);

    return GestureDetector(
      onTap: () {
        setState(() {
          activeselection = label;
          if (activeselection == "Kos") {
            dataList = List.from(kosList);
          } else {
            dataList1 = List.from(makananList);
          }
        });
      },
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: iconAndTextColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: iconAndTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
