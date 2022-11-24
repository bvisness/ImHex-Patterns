#pragma MIME application/wasm
#pragma endian little

#include <std/mem.pat>
#include <type/leb128.pat>

enum SectionID : u8 {
	Custom = 0,
	Type,
	Import,
	Function,
	Table,
	Memory,
	Global,
	Export,
	Start,
	Element,
	Code,
	Data,
	DataCount
};

//
// Types
//

enum NumberType : u8 {
	i32 = 0x7F,
	i64 = 0x7E,
	f32 = 0x7D,
	f64 = 0x7C,
};

enum VectorType : u8 {
	v128 = 0x7B,
};

enum ReferenceType : u8 {
	funcref = 0x70,
	externref = 0x6F,
};

union ValueType {
	NumberType numberType;
	VectorType vectorType;
	ReferenceType referenceType;
};

struct ResultType {
	type::LEB128 size;
	ValueType valueTypes[size];
};

struct FuncType {
	u8 type; // 0x60
	ResultType params;
	ResultType result;
};

struct Limits {
	bool hasMax;
	type::LEB128 min;
	if (hasMax) {
		type::LEB128 max;
	}
};

struct MemoryType {
	Limits limits;
};

struct TableType {
	ReferenceType elementType;
	Limits limits;
};

struct GlobalType {
	ValueType type;
	bool mutable;
};

//
// Instructions
//

enum Opcode : u8 {
	// Control instructions
	unreachable 	= 0x00,
	nop 			= 0x01,
	block 			= 0x02,
	loop 			= 0x03,
	if_ 			= 0x04,
	br 				= 0x0C,
	br_if 			= 0x0D,
	br_table 		= 0x0E,
	return_			= 0x0F,
	call			= 0x10,
	call_indirect	= 0x11,
	
	// Reference instructions
	ref_null		= 0xD0,
	ref_is_null		= 0xD1,
	ref_func		= 0xD2,
	
	// Parametric instructions
	drop			= 0x1A,
	select			= 0x1B, // select without value type
	select_type		= 0x1C, // select with value type
	
	// Variable instructions
	local_get		= 0x20,
	local_set		= 0x21,
	local_tee		= 0x22,
	global_get		= 0x23,
	global_set		= 0x24,
	
	// Table instructions
	table_get		= 0x25,
	table_set		= 0x26,
	// remaining instructions are in other_stuff
	
	// Memory instructions
	i32_load		= 0x28,
	i64_load		= 0x29,
	f32_load		= 0x2A,
	f64_load		= 0x2B,
	i32_load8_s		= 0x2C,
	i32_load8_u		= 0x2D,
	i32_load16_s	= 0x2E,
	i32_load16_u	= 0x2F,
	i64_load8_s		= 0x30,
	i64_load8_u		= 0x31,
	i64_load16_s	= 0x32,
	i64_load16_u	= 0x33,
	i64_load32_s	= 0x34,
	i64_load32_u	= 0x35,
	i32_store		= 0x36,
	i64_store		= 0x37,
	f32_store		= 0x38,
	f64_store		= 0x39,
	i32_store8		= 0x3A,
	i32_store16		= 0x3B,
	i64_store8		= 0x3C,
	i64_store16		= 0x3D,
	i64_store32		= 0x3E,
	memory_size		= 0x3F,
	memory_grow		= 0x40,
	// remaining instructions are in other_stuff
	
	// Numeric instructions
	i32_const		= 0x41,
	i64_const		= 0x42,
	f32_const		= 0x43,
	f64_const		= 0x44,
	
	i32_eqz			= 0x45,
	i32_eq			= 0x46,
	i32_ne			= 0x47,
	i32_lt_s		= 0x48,
	i32_lt_u		= 0x49,
	i32_gt_s		= 0x4A,
	i32_gt_u		= 0x4B,
	i32_le_s		= 0x4C,
	i32_le_u		= 0x4D,
	i32_ge_s		= 0x4E,
	i32_ge_u		= 0x4F,
	
	i64_eqz			= 0x50,
	i64_eq			= 0x51,
	i64_ne			= 0x52,
	i64_lt_s		= 0x53,
	i64_lt_u		= 0x54,
	i64_gt_s		= 0x55,
	i64_gt_u		= 0x56,
	i64_le_s		= 0x57,
	i64_le_u		= 0x58,
	i64_ge_s		= 0x59,
	i64_ge_u		= 0x5A,
	
	f32_eq			= 0x5B,
	f32_ne			= 0x5C,
	f32_lt			= 0x5D,
	f32_gt			= 0x5E,
	f32_le			= 0x5F,
	f32_ge			= 0x60,
	
	f64_eq			= 0x61,
	f64_ne			= 0x62,
	f64_lt			= 0x63,
	f64_gt			= 0x64,
	f64_le			= 0x65,
	f64_ge			= 0x66,
	
	i32_clz			= 0x67,
	i32_ctz			= 0x68,
	i32_popcnt		= 0x69,
	i32_add			= 0x6A,
	i32_sub			= 0x6B,
	i32_mul			= 0x6C,
	i32_div_s		= 0x6D,
	i32_div_u		= 0x6E,
	i32_rem_s		= 0x6F,
	i32_rem_u		= 0x70,
	i32_and			= 0x71,
	i32_or			= 0x72,
	i32_xor			= 0x73,
	i32_shl			= 0x74,
	i32_shr_s		= 0x75,
	i32_shr_u		= 0x76,
	i32_rotl		= 0x77,
	i32_rotr		= 0x78,
	
	i64_clz			= 0x79,
	i64_ctz			= 0x7A,
	i64_popcnt		= 0x7B,
	i64_add			= 0x7C,
	i64_sub			= 0x7D,
	i64_mul			= 0x7E,
	i64_div_s		= 0x7F,
	i64_div_u		= 0x80,
	i64_rem_s		= 0x81,
	i64_rem_u		= 0x82,
	i64_and			= 0x83,
	i64_or			= 0x84,
	i64_xor			= 0x85,
	i64_shl			= 0x86,
	i64_shr_s		= 0x87,
	i64_shr_u		= 0x88,
	i64_rotl		= 0x89,
	i64_rotr		= 0x8A,
	
	f32_abs			= 0x8B,
	f32_neg			= 0x8C,
	f32_ceil		= 0x8D,
	f32_floor		= 0x8E,
	f32_trunc		= 0x8F,
	f32_nearest		= 0x90,
	f32_sqrt		= 0x91,
	f32_add			= 0x92,
	f32_sub			= 0x93,
	f32_mul			= 0x94,
	f32_div			= 0x95,
	f32_min			= 0x96,
	f32_max			= 0x97,
	f32_copysign	= 0x98,
	
	f64_abs			= 0x99,
	f64_neg			= 0x9A,
	f64_ceil		= 0x9B,
	f64_floor		= 0x9C,
	f64_trunc		= 0x9D,
	f64_nearest		= 0x9E,
	f64_sqrt		= 0x9F,
	f64_add			= 0xA0,
	f64_sub			= 0xA1,
	f64_mul			= 0xA2,
	f64_div			= 0xA3,
	f64_min			= 0xA4,
	f64_max			= 0xA5,
	f64_copysign	= 0xA6,
	
	i32_wrap_i64		= 0xA7,
	i32_trunc_f32_s		= 0xA8,
	i32_trunc_f32_u		= 0xA9,
	i32_trunc_f64_s		= 0xAA,
	i32_trunc_f64_u		= 0xAB,
	i64_extend_i32_s	= 0xAC,
	i64_extend_i32_u	= 0xAD,
	i64_trunc_f32_s		= 0xAE,
	i64_trunc_f32_u		= 0xAF,
	i64_trunc_f64_s		= 0xB0,
	i64_trunc_f64_u		= 0xB1,
	f32_convert_i32_s	= 0xB2,
	f32_convert_i32_u	= 0xB3,
	f32_convert_i64_s	= 0xB4,
	f32_convert_i64_u	= 0xB5,
	f32_demote_f64		= 0xB6,
	f64_convert_i32_s	= 0xB7,
	f64_convert_i32_u	= 0xB8,
	f64_convert_i64_s	= 0xB9,
	f64_convert_i64_u	= 0xBA,
	f64_promote_f32		= 0xBB,
	i32_reinterpret_f32	= 0xBC,
	i64_reinterpret_f64	= 0xBD,
	f32_reinterpret_i32	= 0xBE,
	f64_reinterpret_i64	= 0xBF,
	
	i32_extend8_s	= 0xC0,
	i32_extend16_s	= 0xC1,
	i64_extend8_s	= 0xC2,
	i64_extend16_s	= 0xC3,
	i64_extend32_s	= 0xC4,
	
	// And finally, the saturating truncation instructions
	// are all under other_stuff.
	
	// Vector instructions
	vector			= 0xFD, // all vector instructions share a common opcode
	
	other_stuff		= 0xFC, // disambiguated by following byte
};

// TODO: This is not really right, but at least it should decode ok for now.
// See the spec: https://webassembly.github.io/spec/core/binary/instructions.html#binary-blocktype
// using BlockType = type::LEB128;
// TODO: also this crashes?

struct MemArg {
	type::LEB128 align;
	type::LEB128 offset;
};

struct Instruction {
	Opcode opcode;
	
	if (false) {
	} else if (opcode == Opcode::block || opcode == Opcode::loop) {
		type::LEB128 blockType;
		Instruction instructions[while(std::mem::read_unsigned($, 1) != 0x0B)];
		padding[1]; // 0x0B
	} else if (opcode == Opcode::if_) {
		type::LEB128 blockType;
		Instruction trueBlock[while(std::mem::read_unsigned($, 1) != 0x05 && std::mem::read_unsigned($, 1) != 0x0B)];
		u8 endOrElse; // 0x05 or 0x0B
		if (endOrElse == 0x05) {
    		Instruction falseBlock[while(std::mem::read_unsigned($, 1) != 0x0B)];
    		padding[1]; // 0x0B
    	}
	} else if (opcode == Opcode::br || opcode == Opcode::br_if) {
		type::LEB128 labelIndex;
	} else if (opcode == Opcode::br_table) {
		type::LEB128 numLabels;
		type::LEB128 labelIndices[numLabels];
		type::LEB128 defaultLabelIndex;
	} else if (opcode == Opcode::call) {
		type::LEB128 funcIndex;
	} else if (opcode == Opcode::call_indirect) {
		type::LEB128 funcTypeIndex;
		type::LEB128 tableIndex;
	} else if (opcode == Opcode::ref_null) {
		ReferenceType referenceType;
	} else if (opcode == Opcode::ref_func) {
		type::LEB128 funcIndex;
	} else if (Opcode::local_get <= opcode && opcode <= Opcode::local_tee) {
		type::LEB128 localIndex;
	} else if (opcode == Opcode::global_get || opcode == Opcode::global_set) {
		type::LEB128 globalIndex;
	} else if (opcode == Opcode::table_get || opcode == Opcode::table_set) {
		type::LEB128 tableIndex;
	} else if (Opcode::i32_load <= opcode && opcode <= Opcode::i64_store32) {
		MemArg memArg;
	} else if (opcode == Opcode::memory_size || opcode == Opcode::memory_grow) {
		padding[1]; // 0x00, reserved for multi-memory
	} else if (opcode == Opcode::i32_const || opcode == Opcode::i64_const) {
		type::LEB128 value;
	} else if (opcode == Opcode::f32_const) {
		float value;
	} else if (opcode == Opcode::f64_const) {
		double value;
	} else {}
};

struct Expression {
	// TODO: Rich instructions
	// also this prevents things from decoding correctly at all
	Instruction instructions[while(std::mem::read_unsigned($, 1) != 0x0B)];
	padding[1]; // 0x0B (end)
};

//
// Sections & modules
//

struct Name {
	type::LEB128 size;
	char name[size];
} [[format("format_Name")]];

fn format_Name(Name name) {
	return name.name;
};

struct TypeSection {
	type::LEB128 size;
	FuncType funcTypes[size];
};

enum ImportExportID : u8 {
	Func = 0x00,
	Table,
	Memory,
	Global,
};

struct Import {
	Name mod;
	Name name;
	ImportExportID type;
	
	if (type == ImportExportID::Func) {
		type::LEB128 funcTypeIndex;
	} else if (type == ImportExportID::Table) {
		TableType tableType;
	} else if (type == ImportExportID::Memory) {
		MemoryType memType;
	} else if (type == ImportExportID::Global) {
		GlobalType globalType;
	}
};

struct ImportSection {
	type::LEB128 size;
	Import imports[size];
};

struct FunctionSection {
	type::LEB128 size;
	type::LEB128 funcTypeIndices[size]; // TODO: point to somewhere
};

struct TableSection {
	type::LEB128 size;
	TableType tables[size];
};

struct MemorySection {
	type::LEB128 size;
	MemoryType memories[size];
};

struct Global {
	GlobalType type;
	Expression init;
};

struct GlobalSection {
	type::LEB128 size;
	Global globals[size];
};

struct Export {
	Name name;
	ImportExportID type;
	
	if (type == ImportExportID::Func) {
		type::LEB128 funcIndex;
	} else if (type == ImportExportID::Table) {
		type::LEB128 tableIndex;
	} else if (type == ImportExportID::Memory) {
		type::LEB128 memoryIndex;
	} else if (type == ImportExportID::Global) {
		type::LEB128 globalIndex;
	}
};

struct ExportSection {
	type::LEB128 size;
	Export exports[size];
};

struct StartSection {
	type::LEB128 funcIndex;
};

enum ElementKind : u8 {
	funcref = 0x00,
};

struct Element {
	type::LEB128 flags;
	
	// This stuff is super wack. I have broken it down for myself
	// this way:
	//
	// bit 0: 0 = passive/declarative (see bit 1). 1 = active.
	// bit 1: 0 = active uses table 0, or choose passive. 1 = active requires table index, or choose declarative.
	// bit 2: 0 = use elemkind and element indices (only funcs right now). 1 = use reftype and element expressions (funcs or externrefs).
	//
	// Verify for yourself in the spec:
	// https://webassembly.github.io/spec/core/binary/modules.html#binary-elemsec
	
	// TODO: offset expr (e)
	
	if (flags & 0b011) {
		type::LEB128 tableIndex;
	}
	
	if (flags & 0b001) {
		Expression offset;
	}
	
	if (flags & 0b011 == 0) {
		// table type hardcoded to funcref
	} else {
		if (flags & 0b100 == 0) {
			ElementKind elementType;
		} else {
			ReferenceType elementType;
		}
	}

	type::LEB128 size;
	if (flags & 0b100 == 0) {
		type::LEB128 funcIndexes[size];
	} else {
		Expression elementExpressions[size];
	}
};

struct ElementSection {
	type::LEB128 size;
	Element elements[size];
};

struct Locals {
	type::LEB128 num;
	ValueType type;
};

struct CodeEntry {
	type::LEB128 size;
	type::LEB128 numLocals;
	Locals locals[numLocals];
	Expression body;
};

struct CodeSection {
	type::LEB128 size;
	CodeEntry entries[size];
};

struct DataSegment {
	type::LEB128 flags;
	
	if (flags & 0b10) {
		type::LEB128 memoryIndex;
	}
	
	if (flags & 0b00 == 0) {
		// Active segment
		Expression offset;
	}
	
	type::LEB128 size;
	u8 data[size];
};

struct DataSection {
	type::LEB128 size;
	DataSegment segments[size];
};

struct DataCountSection {
	type::LEB128 numSegments;
};

struct Section {
	SectionID id;
	type::LEB128 size;
	
	if (id == SectionID::Type) {
		TypeSection typeSection;
	} else if (id == SectionID::Import) {
		ImportSection importSection;
	} else if (id == SectionID::Function) {
		FunctionSection functionSection;
	} else if (id == SectionID::Table) {
		TableSection tableSection;
	} else if (id == SectionID::Memory) {
		MemorySection memorySection;
	} else if (id == SectionID::Global) {
		GlobalSection globalSection;
	} else if (id == SectionID::Export) {
		ExportSection exportSection;
	} else if (id == SectionID::Start) {
		StartSection startSection;
	} else if (id == SectionID::Element) {
		ElementSection elementSection;
	} else if (id == SectionID::Code) {
		CodeSection codeSection;
	} else if (id == SectionID::Data) {
		DataSection dataSection;
	} else if (id == SectionID::DataCount) {
		DataCountSection dataCountSection;
	} else if (id == SectionID::Custom) {
		Name name;
		u8 contents[name.size - size];
	} else {
		u8 contents[size];
	}
};

struct Module {
	char magic[4];
	u32 version;
	
	Section sections[while (!std::mem::eof())];
};

Module module @ 0x00;
//Expression blep @ 0x7F;
//CodeEntry blep @ 0x7D;
//CodeSection blep @ 0x7C;








